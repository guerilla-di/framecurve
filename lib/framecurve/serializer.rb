# Writes out a Curve object to the passed IO
class Framecurve::Serializer
  # Serialize the passed curve into io. Will use the materialized curve version.
  # Will write the file with CRLF linebreaks instead of LF
  def serialize(io, curve)
    io.write("# http://framecurve.org/specification-v1\n")
    io.write("# at_frame\tuse_frame_of_source\n")
    curve.to_materialized_curve.each_tuple do | t |
      io.write(t)
      io.write("\r\n")
    end
  end
end