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

    context "without a key" do
      test "restore unnested" do
        refute_change 'config.basic' do
          with_config(config) do |c|
            c.basic = 5
            assert_equal 5, config.basic
          end
        end
      end

      test "restore nested" do
        refute_change 'config.nest.level' do
          with_config(config) do |c|
            c.nest.level = 2
            assert_equal 2, config.nest.level
          end
        end
      end
    end

    context "with nested keys" do
      test "restore valid nested key" do
        refute_change 'config.nest.deep.level' do
          with_config(config, :nest, :deep) do |c|
            c.level = 23
            assert_equal 23, config.nest.deep.level
          end
        end
      end

      test "key not found raises ArgumentError" do
        error = assert_raises ArgumentError do
          with_config(config, :some_key, :not_found) {}
        end
        assert_match %r{not found}, error.message
      end

      test "can't change basic value" do
        error = assert_raises ArgumentError do
          with_config(config, :basic) {}
        end
        assert_match %r{can't be cloned}, error.message
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
