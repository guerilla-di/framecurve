require "rexml/document"

module Framecurve
module Extractors

# Pulls all varispeed timeremaps from an FCP XML V4 file
class FCP_XML_InterchangeV4
  include REXML
  
  def extract(io)
    doc = Document.new(io)
    # Find all of the parameterid elements with graphdict
    curvedicts = XPath.each( doc, "//parameterid") do | e |
      if e.text == "graphdict"
        parameter = e.parent
        effect = parameter.parent
        if XPath.first(effect, "name").text == "Time Remap"
          $stderr.puts "Found a timewarp at %s" % parameter.xpath
          
          curve = pull_timewarp(parameter)
          destination = increment_filename(curve.filename)
          File.open(destination, "wb") do | f |
            $stderr.puts "Writing out a framecurve to %s" % destination
            Framecurve::Serializer.new.serialize(f, curve)
          end
          
        end
      end
    end
  end
  
  def increment_filename(filename)
    counter = 0
    while File.exist?(filename)
      counter += 1
      filename = filename.gsub(/(-\d+)?\.framecurve\.txt$/, '-%d.framecurve.txt' % counter)
    end
    filename
  end
  
  def pull_timewarp(param)
    clipitem = param.parent.parent.parent
    c = Framecurve::Curve.new
    $stderr.puts clipitem.xpath
    
    c.comment!("Information from %s" % clipitem.xpath)
    
    clip_item_name = XPath.first(clipitem, "name").text
    
    # The clip in point in the edit timeline, also first frame of the TW
    in_point = XPath.first(clipitem, "in").text.to_i
    out_point = XPath.first(clipitem, "out").text.to_i
    
    c.filename = [clip_item_name, "framecurve.txt"].join('.')
    
    # Accumulate keyframes
    XPath.each(param, "keyframe") do | kf |
      kf_when, kf_value = XPath.first(kf, "when").text.to_i, XPath.first(kf, "value").text.to_f
      # TODO: should be a flag
      kf_when -= in_point
      kf_when += 1
      # kf_value -= in_point
      kf_value += 1
      unless kf_when < 1 || kf_value < 1 || kf_when > out_point
        c.tuple!(kf_when, kf_value)
      end
    end
    $stderr.puts("Generated a curve of #{c.length} keys")
    c
  end
end
end
end