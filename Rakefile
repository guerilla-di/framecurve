# encoding: utf-8

require 'jeweler'
require './lib/framecurve'

Jeweler::Tasks.new do |gem|
  # gem is a Gem::Specification... see http://docs.rubygems.org/read/chapter/20 for more options
  gem.version = Framecurve::VERSION
  gem.name = "framecurve"
  gem.homepage = "http://github.com/guerilla-di/framecurve"
  gem.license = "MIT"
  gem.summary = %Q{ Handles Framecurve files }
  gem.description = %Q{ Parser, validation and interpolation}
  gem.email = "me@julik.nl"
  gem.authors = ["Julik"]
  # dependencies defined in Gemfile
end
Jeweler::RubygemsDotOrgTasks.new

require 'rake/testtask'
Rake::TestTask.new(:test) do |test|
  test.libs << 'lib' << 'test'
  test.pattern = 'test/**/test_*.rb'
  test.verbose = true
end

task :default => :test