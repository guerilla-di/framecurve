require File.dirname(__FILE__) + '/helper'

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
    messages = ["The framecurve did not contain any frame correlation records",
        "The framecurve did not contain any lines at all"]
    assert_equal Set.new(messages), Set.new(v.errors)
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
    assert !v.ok?
    assert v.any_errors?
    assert_equal ["The frame sequencing is out of order (expected [1, 10] but got [10, 1]). The framecurve spec mandates that frames are recorded sequentially"], v.errors
  end
  
  def test_should_error_out_with_linebreaks_in_comment
    c = Framecurve::Curve.new( Framecurve::Comment.new("Foo bar \r\n"), Framecurve::Tuple.new(10, 123.4))
    v = Framecurve::Validator.new
    v.validate(c)
    assert !v.ok?
    assert v.any_errors?
    assert_equal ["The comment at line 1 contains a line break"], v.errors
  end
  
  def test_should_error_out_with_neg_source_and_dest_values
    c = Framecurve::Curve.new( Framecurve::Tuple.new(-10, 123.4), Framecurve::Tuple.new(1, -345.67) )
    v = Framecurve::Validator.new
    v.validate(c)
    assert v.any_errors?
    errs = ["The line 1 had it's at_frame value (-10) below 1. The spec mandates at_frame >= 1.",
      "The line 2 had a use_frame_of_source value (-345.67000) below 0. The spec mandates use_frame_of_source >= 0."]
    assert !v.ok?
    assert_equal errs, v.errors
  end
  
  def test_parse_from_err_bad_extension
    v = Framecurve::Validator.new
    v.parse_and_validate(File.dirname(__FILE__) + "/fixtures/framecurves/incorrect.extension")
    assert !v.ok?
    assert_equal ["The framecurve file has to have the .framecurve.txt double extension, but had \".extension\""], v.errors
  end
  
  def test_parse_from_err_neg_frames
    v = Framecurve::Validator.new
    v.parse_and_validate(File.dirname(__FILE__) + "/fixtures/framecurves/err-neg-frames.framecurve.txt")
    assert !v.ok?
    assert_equal ["The line 3 had it's at_frame value (-1) below 1. The spec mandates at_frame >= 1."], v.errors
  end
  
  def test_parse_from_err_no_tuples
    v = Framecurve::Validator.new
    v.parse_and_validate(File.dirname(__FILE__) + "/fixtures/framecurves/err-no-tuples.framecurve.txt")
    assert !v.ok?
    assert_equal ["The framecurve did not contain any frame correlation records"], v.errors
  end
  
  def test_should_warn_without_preamble_url
    c = Framecurve::Curve.new( Framecurve::Tuple.new(10, 123.4))
    v = Framecurve::Validator.new
    v.validate(c)
    assert v.any_warnings?
    assert !v.ok?
    assert v.warnings.include?("It is recommended that a framecurve starts with a comment with the specification URL")
  end
  
  def test_should_warn_without_preamble_headers
    c = Framecurve::Curve.new( Framecurve::Comment.new("http://framecurve.org/specification-v1"), Framecurve::Tuple.new(10, 123.4))
    v = Framecurve::Validator.new
    v.validate(c)
    assert !v.ok?
    assert v.any_warnings?
    assert_equal "It is recommended for the second comment to provide a column header", v.warnings[0]
  end
  
  def test_should_parse_well
    c = Framecurve::Curve.new( 
      Framecurve::Comment.new("http://framecurve.org/specification-v1"), 
      Framecurve::Comment.new("at_frame\tuse_frame_of_source"), 
      Framecurve::Tuple.new(10, 123.4)
    )
    v = Framecurve::Validator.new
    v.validate(c)
    assert v.ok?
  end
end