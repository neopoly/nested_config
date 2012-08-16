require 'helper'

class NestedConfigWithConfigTest < NestedConfigSpec
  require 'nested_config/with_config'
  include NestedConfig::WithConfig

  context "with_config" do
    let(:config) do
      NestedConfig.new.tap do |config|
        config.basic = 23
        config.nest do |nest|
          nest.level = 1
          nest.deep do |deep|
            deep.level = 2
          end
        end
      end
    end

    test "one key" do
      refute_change 'config.nest.level' do
        with_config(config, :nest) do |nest|
          nest.level = 2
          assert_equal 2, config.nest.level
        end
      end
    end
  end

  private

  def refute_change(code)
    before = eval(code)
    yield
  ensure
    after = eval(code)
    assert_equal before, after, "#{code} has changed to #{mu_pp(after)} from #{mu_pp(before)}"
  end
end
