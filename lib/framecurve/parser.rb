class Framecurve::Parser
  COMMENT = /^#(.+)$/
  CORRELATION_RECORD = /^(\d+)\t((\d+(\.\d*)?)|\.\d+)([eE][+-]?[0-9]+)?$/
  
  def parse(io)
    elements = []
    until io.eof?
      str = io.gets("\n")
      
      # We mandate CRLF linebreaks unless the file ends on THAT line
      if str[-2..-1] != "\r\n" && !io.eof?
        raise Framecurve::Malformed, "Framecurve mandates CRLF linebreaks, yours only has LF"
      end
      
      str = str.strip
      item = if str =~ COMMENT
        extract_comment(str)
      elsif str =~ CORRELATION_RECORD
        extract_tuple(str)
      else
        raise Malformed, "Malformed line #{str} at offset #{io.pos}, line #{io.lineno}"
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