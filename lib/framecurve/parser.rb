class Framecurve::Parser
  COMMENT = /^#(.+)$/
  CORRELATION_RECORD = /^(\d+)\t((\d+(\.\d*)?)|\.\d+)([eE][+-]?[0-9]+)?$/
  
  def parse(io)
    @line_counter = 0 # IO#lineno is not exactly super-reliable
    elements = []
    until io.eof?
      str = io.gets("\n")
      @line_counter += 1
      
      # We mandate CRLF linebreaks unless the file ends on THAT line
      if str[-2..-1] != "\r\n" && !io.eof?
        raise Framecurve::Malformed, "Framecurve mandates CRLF linebreaks, yours only has LF (at line #{@line_counter})" 
      end
      
      str = str.strip
      item = if str =~ COMMENT
        extract_comment(str)
      elsif str =~ CORRELATION_RECORD
        extract_tuple(str)
      else
        raise Framecurve::Malformed, "Malformed line #{str.inspect} at offset #{io.pos}, line #{@line_counter}"
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