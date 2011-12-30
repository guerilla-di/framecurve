module Framecurve
  VERSION = "1.0.3"
  
  # Is raised when a malformed framecurve bit has occurred in the system
  class Malformed < RuntimeError
  end
end

%w( tuple comment curve parser validator serializer ).each do | f |
  require File.join(File.dirname(__FILE__), "framecurve", f)
end