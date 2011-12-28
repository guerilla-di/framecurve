class Framecurve::Serializer
  def serialize(io, curve)
    curve.each do | element |
      if element.tuple?
        io.write("# %s\r\n" % element.text)
      elsif element.comment?
        io.write("%d\t%05f\r\n" % [element.at, element.value])
      end
    end
  end
end