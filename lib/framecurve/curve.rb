# Represents a curve file with comments and frame correlation records
class Framecurve::Curve
  
  def initialize(elements = [])
    @elements = elements
  end
  
  # Iterates over all the tuples in the curve
  def each_tuple
    @elements.each do | e |
      yield(e) if e.tuple?
    end
  end
  
  # Return the tuples in this curve
  def only_tuples
    @elements.collect{|e| e.tuple? }
  end
  
  # Iterates over all the elements in the curve
  def each
    @elements.each(&Proc.new)
  end
  
  # Iterates over all the comments in the curve
  def each_comment
    @elements.each do | e |
      yield(e) if e.comment?
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
    @elements.any{|e| e.tuple? }
  end
  
end