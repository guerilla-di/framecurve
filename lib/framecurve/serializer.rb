class Framecurve::Serializer
  def serialize(io, curve)
    io.write("# http://framecurve.org/specification-v1\n")
    io.write("# at_frame\tuse_frame_of_source\n")
    # TODO - lerp instead!
    curve.each do | element |
      if element.tuple?
        io.write("# %s\r\n" % element.text)
      elsif element.comment?
        io.write("%d\t%05f\r\n" % [element.at, element.value])
      end
    end
  end
end