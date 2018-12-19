# -*- encoding: utf-8 -*-
# stub: framecurve 2.2.2 ruby lib

require File.dirname(__FILE__) + '/lib/framecurve/version'
Gem::Specification.new do |s|
  s.name = "framecurve"
  s.version = Framecurve::VERSION

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.require_paths = ["lib"]
  s.authors = ["Julik"]
  s.date = Time.now.utc.strftime("%Y-%m-%d")
  s.description = "Framecurve parser, validation and interpolation"
  s.email = "me@julik.nl"
  s.executables = ["framecurve_from_fcp_xml", "framecurve_validator"]
  s.extra_rdoc_files = [
    "LICENSE.txt",
    "README.rdoc"
  ]
  s.files = `git ls-files -z`.split("\x0")
  s.homepage = "http://github.com/guerilla-di/framecurve"
  s.licenses = ["MIT"]
  s.rubygems_version = "2.2.2"
  s.summary = "Handles Framecurve files"

  s.specification_version = 4

  s.add_development_dependency('rake', '~> 10')
  s.add_development_dependency('cli_test')
  s.add_development_dependency('test-unit')
end
