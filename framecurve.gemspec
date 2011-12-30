# Generated by jeweler
# DO NOT EDIT THIS FILE DIRECTLY
# Instead, edit Jeweler::Tasks in Rakefile, and run 'rake gemspec'
# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = "framecurve"
  s.version = "1.0.0"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["Julik"]
  s.date = "2011-12-30"
  s.description = "TODO: longer description of your gem"
  s.email = "me@julik.nl"
  s.executables = ["framecurve_validator"]
  s.extra_rdoc_files = [
    "LICENSE.txt",
    "README.rdoc"
  ]
  s.files = [
    ".document",
    "Gemfile",
    "LICENSE.txt",
    "README.rdoc",
    "Rakefile",
    "bin/framecurve_validator",
    "lib/framecurve.rb",
    "lib/framecurve/comment.rb",
    "lib/framecurve/curve.rb",
    "lib/framecurve/parser.rb",
    "lib/framecurve/serializer.rb",
    "lib/framecurve/tuple.rb",
    "lib/framecurve/validator.rb",
    "test/helper.rb",
    "test/test_framecurve_comment.rb",
    "test/test_framecurve_curve.rb",
    "test/test_framecurve_parser.rb",
    "test/test_framecurve_tuple.rb",
    "test/test_framecurve_validator.rb"
  ]
  s.homepage = "http://github.com/julik/framecurve"
  s.licenses = ["MIT"]
  s.require_paths = ["lib"]
  s.rubygems_version = "1.8.11"
  s.summary = "TODO: one-line summary of your gem"

  if s.respond_to? :specification_version then
    s.specification_version = 3

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_runtime_dependency(%q<term-ansicolor>, [">= 0"])
      s.add_development_dependency(%q<jeweler>, ["~> 1.6.4"])
      s.add_development_dependency(%q<rake>, [">= 0"])
    else
      s.add_dependency(%q<term-ansicolor>, [">= 0"])
      s.add_dependency(%q<jeweler>, ["~> 1.6.4"])
      s.add_dependency(%q<rake>, [">= 0"])
    end
  else
    s.add_dependency(%q<term-ansicolor>, [">= 0"])
    s.add_dependency(%q<jeweler>, ["~> 1.6.4"])
    s.add_dependency(%q<rake>, [">= 0"])
  end
end

