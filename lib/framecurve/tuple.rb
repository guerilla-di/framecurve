# Represents one Framecurve frame correlation record
class Framecurve::Tuple < Struct.new(:at, :value)
  def tuple?
    true
  end
  
  def comment?
    false
  end
  
  def to_s
    "%d\t%05f" % [at, value]
  end
end
