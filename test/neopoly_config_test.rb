require 'helper'

class NeopolyConfigTest < NeopolyConfigSpec

  context "basic" do
    let(:config) { Neopoly::Config.new }

    test "empty" do
      assert config.__hash__.empty?
    end

    test "sets values" do
      c = config.tap do |c|
        c.foo = :bar
        c.bar = :baz
      end

      assert_equal :bar, c.foo
      assert_equal :baz, c.bar
      assert_nil c.unknown
    end

    test "sets deep values" do
      c = config.tap do |c|
        c.deep do |deep|
          deep.key = :foo
          deep.deeper do |deeper|
            deeper.key = :bar
          end
        end
        c.deep2 do |deep2|
          deep2.key = :baz
        end
      end

      assert_equal :foo, c.deep.key
      assert_equal :bar, c.deep.deeper.key
      assert_equal :baz, c.deep2.key
    end

    test "cannot nest nil" do
      c = config.tap do |c|
        c.key = :foo
      end

      e = assert_raises NoMethodError do
        c.deep.deeper.key
      end
      assert_match /NilClass/, e.message
    end
  end
end
