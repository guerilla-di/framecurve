# Validates a Curve object for well-formedness and completeness.
#   v = Validator.new
#   v.parse(io_handle)
#   v.errors => []
#   v.warnings => ["Do not put cusswords in your framecurves"]
class Framecurve::Validator
  attr_reader :warnings, :errors
  
  def initialize
    @warnings, @errors = [], []
  end
  
  def any_errors?
    @errors.any?
  end
  
  def any_warnings?
    @warnings.any?
  end
  
  # Parse and validate a file (API similar to Parser#parse)
  def parse_and_validate(path_or_io)
    begin
      validate(Framecurve::Parser.new.parse(path_or_io))
    rescue Framecurve::Malformed => e
      @errors.push(e.message)
    end
  end
  
  # Validate a passed Curve object
  def validate(curve)
    initialize # reset
    methods_matching(/^(verify|recommend)/).each do | method_name |
      method(method_name).call(curve)
    end
  end
  
  private
  
  def methods_matching(pattern)
    private_methods.select { |m|  m.to_s =~ pattern }
  end
  
  def verify_at_least_one_line(curve)
    @errors.push("The framecurve did not contain any lines at all") if curve.empty?
  end
  
  def verify_at_least_one_tuple(curve)
    first_tuple = curve.find{|e| e.tuple? }
    @errors.push("The framecurve did not contain any frame correlation records") unless first_tuple
  end
  
  def verify_proper_sequencing(curve)
    tuples = curve.select{|e| e.tuple? }
    frame_numbers = tuples.map{|t| t.at }
    proper_sequence = frame_numbers.sort
    
    unless frame_numbers == proper_sequence
      @errors.push("The frame sequencing is out of order " + 
      "(expected #{proper_sequence.inspect} but got #{frame_numbers.inspect})." +
      " The framecurve spec mandates that frames are recorded sequentially") 
    end
  end
  
  def verify_non_negative_source_and_destination_frames(curve)
    curve.each_with_index do | t, i |
      next unless t.tuple?
      
      line_no = i + 1
      if t.at < 0
        @errors.push("The tuple %d had a negative at_frame value (%d). The spec mandates positive frames." % [line_no, t.at])
      elsif t.value < 0
        @errors.push("The tuple %d had a negative use_frame_of_source value (%.5f). The spec mandates positive frames." % [line_no, t.value])
      end
    end
  end
  
  def verify_file_naming(curve)
    return unless curve.respond_to?(:filename) && curve.filename
    unless curve.filename =~ /\.framecurve\.txt$/
      @errors.push("The framecurve file has to have the .framecurve.txt double extension, but had %s" % File.extname(curve.filename).inspect)
    end
  end
  
  def verify_no_duplicate_records(curve)
    detected_dupes = []
    curve.each do | t |
      next unless t.tuple?
      next if detected_dupes.include?(t.at)
      elements = curve.select{|e| e.tuple? && e.at == t.at }
      if elements.length > 1
        detected_dupes.push(t.at)
        @errors.push("The framecurve contains the same frame (%d) twice or more (%d times)" % [t.at, elements.length])
      end
    end
  end
  
  def recommend_proper_preamble(curve)
    first_comments = curve.map do | e |
      break unless e.comment?
      e
    end
  end
  
  def recommend_proper_column_headers(curve)
  end
end