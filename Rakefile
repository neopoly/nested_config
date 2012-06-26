require "bundler/gem_tasks"

desc 'Default: run unit tests.'
task :default => :test

# Test
require 'rake/testtask'
Rake::TestTask.new(:test) do |test|
  test.test_files = FileList.new('test/*_test.rb')
  test.libs << 'test'
  test.verbose = true
end

# RDoc
require 'rdoc/task'
RDoc::Task.new(:rdoc) do |rdoc|
  rdoc.rdoc_dir = 'rdoc'
  rdoc.title    = 'nested config'
  rdoc.options << '--line-numbers'
  rdoc.rdoc_files.include('README.rdoc')
  rdoc.rdoc_files.include('lib/**/*.rb')
end
