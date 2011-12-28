module Framecurve
  VERSION = "1.0.0"
  
  # Represents one Framecurve frame correlation record
  class Tuple < Struct.new(:at, :value)
  end
  
  class Comment < Struct.new(:text)
  end
  
  
  # Is raised when a malformed framecurve bit has occurred in the system
  class Malformed < RuntimeError
  end
  
  # Represents a curve file with comments and frame correlation records
  class Curve
    
    def initialize(elements = [])
      @elements = elements
    end
    
    # Iterates over all the tuples in the curve
    def each_tuple
      @elements.each do | e |
        yield(e) if e.is_a?(Tuple)
      end
    end
    
    # Return the tuples in this curve
    def only_tuples
      @elements.collect{|e| e.is_a?(Tuple) }
    end
    
    # Iterates over all the elements in the curve
    def each
      @elements.each(&Proc.new)
    end
    
    # Iterates over all the comments in the curve
    def each_comment
      @elements.each do | e |
        yield(e) if e.is_a?(Comment)
      end
    end
    
    # Adds a comment line
    def comment!(text)
      @elements.push(Comment.new(text.strip))
    end
    
    # Adds a tuple
    def tuple!(at, value)
      at_frame = at.to_i
      
      # Validate for sequencing
      if any_tuples?
        last_frame = only_tuples[-1].at
        if at_frame <= last_frame
          raise Malformed, "Cannot add a frame that comes before or at the same frame as the previous one (%d after %d)" % [at_frame, last_frame]
        end
      end
      
      @elements.push(Tuple.new(at_frame, value.to_f))
    end
    
    # Returns the number of lines in this curve file
    def length
      @elements.length
    end
    
    def empty?
      @elements.empty?
    end
    
    def [](at)
      @elements[at]
    end
    
    def any_tuples?
      @elements.any{|e| e.is_a?(Tuple) }
    end
    
  end
  
  CRLF = "\r\n"
  
  class Parser
    COMMENT = /^#(.+)$/
    CORRELATION_RECORD = /^(\d+)\t((\d+(\.\d*)?)|\.\d+)([eE][+-]?[0-9]+)?$/
    
    def parse(io)
      elements = []
      until io.eof?
        str = io.gets("\n")
        
        # We mandate CRLF linebreaks unless the file ends on THAT line
        if str[-2..-1] != "\r\n" && !io.eof?
          raise Malformed, "Framecurve mandates CRLF linebreaks, yours only has LF"
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
      
      return Curve.new(elements)
    end
    
    def extract_comment(line)
      comment_txt = line.scan(COMMENT).flatten[0].strip
      Comment.new(comment_txt)
    end
    
    def extract_tuple(line)
      slots = line.scan(CORRELATION_RECORD).flatten
      Tuple.new(slots[0].to_i, slots[1].to_f)
    end
  end
  
end