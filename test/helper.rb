if ENV['CODECLIMATE_REPO_TOKEN']
  require "codeclimate-test-reporter"
  CodeClimate::TestReporter.start
end

require 'simplecov' if ENV['COVERAGE']

require 'minitest/spec'
require 'minitest/autorun'

require 'nested_config'

class NestedConfigSpec < MiniTest::Spec
  class << self
    alias :test :it
    alias :context :describe
  end
end
