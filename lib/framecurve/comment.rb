class Framecurve::Comment < Struct.new(:text)
  def tuple?
    false
  end
  
  def comment?
    true
  end
end