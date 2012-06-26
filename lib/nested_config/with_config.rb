class NestedConfig
  # Test helper for modifying config during a block.
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
  #         config.workers do |workers|
  #           workers.max = 5
  #         end
  #       end
  #     end
  #
  #     def test_with_config
  #       with_config(app_config, :workers) do |workers|
  #         workers.max = 1
  #         # do stuff with modified config max value
  #       end
  #       # global config reset to previous config
  #     end
  #   end
  module WithConfig
    def with_config(config, key)
      current = config[key]
      backup  = current.__clone__
      yield current
    ensure
      config[key] = backup
    end
  end
end
