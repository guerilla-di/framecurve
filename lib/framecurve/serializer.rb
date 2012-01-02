# Writes out a Curve object to the passed IO
class Framecurve::Serializer
  # Serialize the passed curve into io. Will use the materialized curve version.
  # Will write the file with CRLF linebreaks instead of LF
  def serialize(io, curve)
    io.write("# http://framecurve.org/specification-v1\n")
    io.write("# at_frame\tuse_frame_of_source\n")
    curve.each do | record |
      io.write("%s\r\n" % record)
    end
  end
end