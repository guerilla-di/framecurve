require "bundler/gem_tasks"
require 'rake/testtask'

desc "Run all tests"
Rake::TestTask.new("test") do |t|
  t.libs << "test"
  t.pattern = 'test/**/test_*.rb'
  t.verbose = true
end

task :update_license_date do
  license_path = File.dirname(__FILE__) + "/LICENSE.txt"
  license_text = File.read(license_path)
  license_text.gsub!(/2009\-(\d+)/, "2009-#{Time.now.year + 1}")
  File.open(license_path, "w"){|f| f << license_text }
end

# Automatically update the LICENSE
Rake::Task[:test].enhance [:update_license_date]
task :default => [ :test ]
