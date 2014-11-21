require 'nested_config/version'

# Simple, static, nested application configuration.
#
# == Example
#
#   require 'nested_config'
#
#   class MyApp
#     def self.configure
#       yield config
#     end
#
#     def self.config
#       @config ||= MyConfig.new
#     end
#
#     class MyConfig < NestedConfig
#     end
#   end
#
#   MyApp.configure do |config|
#     config.coins = 1000
#     config.user do |user|
#       user.max = 5
#     end
#     config.queue do |queue|
#       queue.workers do |workers|
#         workers.max = 2
#         workers.timeout = 60.seconds
#       end
#     end
#   end
#
class NestedConfig
  autoload :EvaluateOnce, 'nested_config/evaluate_once'

  def initialize
    @hash = {}
  end

  def [](name, *args)
    @hash[name.to_s]
  end

  def []=(name, value)
    @hash[name.to_s] = value
  end

  def __hash__
    @hash
  end

  def __hash__=(hash)
    @hash = hash
  end

  def method_missing(name, *args)
    if block_given?
      config = self[name] ||= self.class.new
      yield config
    else
      key = name.to_s.gsub(/=$/, '')
      if $& == '='
        self[key] = args.first
      else
        self[key, *args]
      end
    end
  end

  def respond_to_missing?(name, include_private=false)
    __hash__.key?(name.to_s) || super
  end
end
