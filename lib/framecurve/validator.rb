# Validates a Curve object for well-formedness and completeness
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