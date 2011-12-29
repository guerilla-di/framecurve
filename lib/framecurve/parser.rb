class Framecurve::Parser
  COMMENT = /^#(.+)$/
  CORRELATION_RECORD = /^([-]?\d+)\t([-]?(\d+(\.\d*)?)|\.\d+)([eE][+-]?[0-9]+)?$/
  
  def parse(path_or_io)
    # If the first argument is a path parse from the opened file, 
    # and record the filename in the curve as well
    unless path_or_io.respond_to?(:read)
       curve = File.open(path_or_io, "r", &method(:parse))
       curve.filename = File.basename(path_or_io)
       return curve
    end
    
    @line_counter = 0 # IO#lineno is not exactly super-reliable
    elements = []
    until path_or_io.eof?
      str = path_or_io.gets("\n")
      @line_counter += 1
      
      str = str.strip
      item = if str =~ COMMENT
        extract_comment(str)
      elsif str =~ CORRELATION_RECORD
        extract_tuple(str)
      else
        raise Framecurve::Malformed, "Malformed line #{str.inspect} at offset #{path_or_io.pos}, line #{@line_counter}"
      end
      elements.push(item)
    end
    
    return Framecurve::Curve.new(elements)
  end
  
  def extract_comment(line)
    comment_txt = line.scan(COMMENT).flatten[0].strip
    Framecurve::Comment.new(comment_txt)
  end
  
  def extract_tuple(line)
    slots = line.scan(CORRELATION_RECORD).flatten
    Framecurve::Tuple.new(slots[0].to_i, slots[1].to_f)
  end
  
end