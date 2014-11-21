class NestedConfig
  # Test helper for modifying config inside a block.
  #
  # == Example
  #
  #   require 'nested_config/with_config'
  #
  #   class MyCase < MiniTest::TestCase
  #     include NestedConfig::WithConfig
  #
  #     def app_config
  #       MyApp.config # global
  #     end
  #   end
  #
  #   class SomeCase < MyCase
  #     def setup
  #       app_config.tap do |config|
  #         config.coins = 1000
  #         config.queue do |queue|
  #           queue.workers do |workers|
  #             workers.max = 5
  #           end
  #         end
  #       end
  #     end
  #
  #     def test_with_basic_value
  #       with_config(app_config) do |config|
  #         config.coins = 500
  #       end
  #       # global config reset to previous config
  #     end
  #
  #     def test_queue_with_changed_workers
  #       with_config(app_config, :queue, :workers) do |workers|
  #         workers.max = 1
  #         # do stuff with modified config max value
  #       end
  #       # global config reset to previous config
  #     end
  #   end
  module WithConfig
    def with_config(config, *keys, &block)
      current = keys.inject(config) do |config, key|
        config[key] or raise KeyNotFound.new(key, keys)
      end
      current.respond_to?(:__hash__) or raise ValueNotCloneable.new(current)

      backup = Marshal.load(Marshal.dump(current.__hash__))
      yield current
    ensure
      current.__hash__ = backup if backup
    end

    class KeyNotFound < ArgumentError
      def initialize(key, keys)
        super(%{config key "#{key}" in config.#{keys.map(&:to_s).join(".")} not found})
      end
    end

    class ValueNotCloneable < ArgumentError
      def initialize(value)
        super(%{config value #{value.inspect} can't be cloned})
      end
    end
  end
end
