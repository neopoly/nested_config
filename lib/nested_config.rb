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

  # Define a config with special names
  #
  # Example:
  #   config = NestedConfig.new.tap do |config|
  #     config._ "mix & match" do |mix_and_match|
  #       mix_and_match.name = "Mix & match"
  #       # ...
  #     end
  #   end
  #
  #   config["mix & match"].name # => Mix & match
  def _(name)
    raise ArgumentError, "provide missing block" unless block_given?
    config = self[name] ||= self.class.new
    yield config
  end

  def method_missing(name, *args, &block)
    if block_given?
      _(name, &block)
    else
      key = name.to_s
      index = key.rindex('='.freeze)
      if index
        key = key[0, index]
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
