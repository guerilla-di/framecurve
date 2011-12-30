require 'helper'

class TestFramecurveValidator < Test::Unit::TestCase
  
  def test_should_error_out_with_malformed_input_to_parse_and_validate
    v = Framecurve::Validator.new
    io = StringIO.new("foobar")
    v.parse_and_validate(io)
    assert v.any_errors?
    assert_equal ["Malformed line \"foobar\" at offset 6, line 1"], v.errors
  end
  
  def test_should_not_error_out_with_good_input_to_parse_and_validate
    v = Framecurve::Validator.new
    io = StringIO.new("# Nice framecurve\r\n1\t146.0")
    v.parse_and_validate(io)
    assert !v.any_errors?
  end
  
  def test_should_try_to_open_file_at_path_if_string_passed_to_parse_and_validate
    v = Framecurve::Validator.new
    assert_raise(Errno::ENOENT) do
      v.parse_and_validate("/tmp/some_file.framecurve.txt")
    end
  end
  
  def test_should_record_filename_error_with_improper_extension
    File.open("wrong.extension", "wb"){|f| f.write("# This might have been\r\n1\t123.45") }
    begin
      v = Framecurve::Validator.new
      v.parse_and_validate("wrong.extension")
      assert v.any_errors?
      assert_equal ["The framecurve file has to have the .framecurve.txt double extension, but had \".extension\""], v.errors
    ensure
      File.unlink("wrong.extension")
    end
  end
  
  def test_should_init_with_empty_errors_and_warnings
    v = Framecurve::Validator.new
    assert !v.any_errors?
    assert !v.any_warnings?
    assert_equal [], v.errors
    assert_equal [], v.warnings
  end
  
  def test_should_error_out_with_empty
    v = Framecurve::Validator.new
    v.validate([])
    assert v.any_errors?
    assert_equal ["The framecurve did not contain any lines at all",
     "The framecurve did not contain any frame correlation records"], v.errors
  end
  
  def test_should_error_out_without_actual_tuples
    c = Framecurve::Curve.new( Framecurve::Comment.new("Only text") )
    v = Framecurve::Validator.new
    v.validate(c)
    assert v.any_errors?
    assert_equal ["The framecurve did not contain any frame correlation records"], v.errors
  end
  
  def test_should_error_out_with_dupe_frames
    c = Framecurve::Curve.new( Framecurve::Tuple.new(10, 123.4), Framecurve::Tuple.new(10, 123.4) )
    v = Framecurve::Validator.new
    v.validate(c)
    assert v.any_errors?
    assert_equal ["The framecurve contains the same frame (10) twice or more (2 times)"], v.errors
  end
  
  def test_should_error_out_with_improper_sequencing
    c = Framecurve::Curve.new( Framecurve::Tuple.new(10, 123.4), Framecurve::Tuple.new(1, 123.4) )
    v = Framecurve::Validator.new
    v.validate(c)
    assert v.any_errors?
    assert_equal ["The frame sequencing is out of order (expected [1, 10] but got [10, 1]). The framecurve spec mandates that frames are recorded sequentially"], v.errors
  end
  
  def test_should_error_out_with_neg_source_and_dest_values
     c = Framecurve::Curve.new( Framecurve::Tuple.new(-10, 123.4), Framecurve::Tuple.new(1, -345.67) )
     v = Framecurve::Validator.new
     v.validate(c)
     assert v.any_errors?
     errs = ["The tuple 1 had a negative at_frame value (-10). The spec mandates positive frames.",
      "The tuple 2 had a negative use_frame_of_source value (-345.67000). The spec mandates positive frames."]
     assert_equal errs, v.errors
   end
end