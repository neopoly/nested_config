require 'helper'

class NestedConfigWithConfigTest < NestedConfigSpec
  require 'nested_config/with_config'
  include NestedConfig::WithConfig

  let(:config) do
    NestedConfig.new.tap do |config|
      config.nest do |nest|
        nest.level = 1
        nest.deep do |deep|
          deep.level = 2
        end
      end
    end
  end

  test "with_config with one key" do
    assert_equal 1, config.nest.level

    with_config(config, :nest) do |nest|
      nest.level = 2
      assert_equal 2, config.nest.level
    end

    assert_equal 1, config.nest.level
  end
end
