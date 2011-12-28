class Framecurve::Comment < Struct.new(:text)
  def tuple?
    false
  end
  
  def comment?
    true
  end
  
  def to_s
    ['#', text.to_s.gsub(/\r\n?/, '')].join(' ')
  end
end