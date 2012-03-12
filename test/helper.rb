# simplecov
require 'simplecov' if ENV['COVERAGE']

require 'rubygems'
require 'minitest/spec'
require 'minitest/autorun'

require 'neopoly/config'

class NeopolyConfigSpec < MiniTest::Spec
  class << self
    alias :test :it
    alias :context :describe
  end
end
