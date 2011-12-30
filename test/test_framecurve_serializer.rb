require 'helper'

class TestFramecurveSerializer < Test::Unit::TestCase
  def test_output
    f = Framecurve::Curve.new(Framecurve::Tuple.new(10, 123))
    s = StringIO.new
    Framecurve::Serializer.new.serialize(s, f)
    assert_equal "# http://framecurve.org/specification-v1\n# at_frame\tuse_frame_of_source\n10\t123.00000\r\n", s.string
  end
  
  def test_materializes_frames
    f = Framecurve::Curve.new(Framecurve::Tuple.new(10, 123), Framecurve::Tuple.new(12, 456))
    s = StringIO.new
    Framecurve::Serializer.new.serialize(s, f)
    assert_equal "# http://framecurve.org/specification-v1\n# at_frame\tuse_frame_of_source\n10\t123.00000\r\n11\t289.00000\r\n12\t456.00000\r\n", s.string
  end
end