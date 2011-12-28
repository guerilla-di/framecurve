module Framecurve
  VERSION = "1.0.0"
  
  # Is raised when a malformed framecurve bit has occurred in the system
  class Malformed < RuntimeError
  end
end

%w( serializer tuple comment curve parser ).each do | f |
  require File.join(File.dirname(__FILE__), "framecurve", f)
end