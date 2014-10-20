module Framecurve
  VERSION = "2.2.2"
  
  # Is raised when a malformed framecurve bit has occurred in the system
  class Malformed < RuntimeError
  end
end

%w( tuple comment curve parser validator serializer extractors/fcp_xml ).each do | f |
  require File.join(File.dirname(__FILE__), "framecurve", f)
end