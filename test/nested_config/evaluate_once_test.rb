require 'helper'

class NestedConfigEvaluateOnceTest < NestedConfigSpec
  let(:config) do
    Class.new(NestedConfig) do
      include NestedConfig::EvaluateOnce
    end.new
  end

  context "evaluates once w/o argument" do
    context "w/o argument" do
      before do
        config.startup_time = proc { Time.now }
      end

      test "has time value" do
        assert_instance_of Time, config.startup_time
      end

      test "value does not change" do
        n = config.startup_time
        assert_same n, config.startup_time
      end
    end

    context "with argument" do
      before do
        config.env = proc { |e| e.to_s.upcase }
        config.env(:development)
      end

      test "replaces original value" do
        assert_equal "DEVELOPMENT", config.env
      end

      test "value does not change" do
        env = config.env
        assert_same env, config.env
      end
    end
  end
end
