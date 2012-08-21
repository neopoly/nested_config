# simplecov
require 'simplecov' if ENV['COVERAGE']

require 'rubygems'
require 'bundler/setup'
require 'minitest/spec'
require 'minitest/autorun'

require 'nested_config'

class NestedConfigSpec < MiniTest::Spec
  class << self
    alias :test :it
    alias :context :describe
  end
end
