# Represents one Framecurve frame correlation record
class Framecurve::Tuple < Struct.new(:at, :value)
  def tuple?
    true
  end
  
  def comment?
    false
  end
end
