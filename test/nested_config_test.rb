require 'helper'

class NestedConfigTest < NestedConfigSpec

  context "basic" do
    let(:config) { NestedConfig.new }

    test "empty" do
      assert config.__hash__.empty?
    end

    test "is NOT a blank slate right now" do
      Object.instance_methods.each do |method|
        assert config.respond_to?(method)
      end
    end

    test "sets raw __hash__" do
      config.__hash__ = { "foo" => 23 }
      assert_equal 23, config.foo
    end

    test "inspect" do
      c = config.tap { |config| config.foo = :bar }

      hash = c.__hash__.inspect
      assert_match %r{#<NestedConfig:0x[0-9a-z]+ @hash=#{hash}>}, c.inspect
    end

    test "cannot use defined method names as keys" do
      c = config.tap do |config|
        config.object_id = :foo
        config.class     = :bar
      end
      refute_equal :foo, c.object_id
      refute_equal :bar, c.class
    end

    test "sets values" do
      c = config.tap do |config|
        config.foo = :bar
        config.bar = :baz
      end

      assert_equal :bar, c.foo
      assert_equal :baz, c.bar
      assert_nil c.unknown
    end

    test "sets deep values" do
      c = config.tap do |config|
        config.deep do |deep|
          deep.key = :foo
          deep.deeper do |deeper|
            deeper.key = :bar
          end
        end
        config.deep2 do |deep2|
          deep2.key = :baz
        end
      end

      assert_equal :foo, c.deep.key
      assert_equal :bar, c.deep.deeper.key
      assert_equal :baz, c.deep2.key
    end

    test "sets arrays as value" do
      c = config.tap do |config|
        config.ary   = [ :foo, :bar ]
        config.ary2  = :foo, :bar
      end

      assert_equal [ :foo, :bar ], c.ary
      assert_equal [ :foo, :bar ], c.ary2
    end

    test "sets nested values via []" do
      c = config.tap do |config|
        config._ "special key" do |o|
          o.key = "special"
        end

        config._ "special key" do |o|
          o.key2 = "again"
        end
      end

      assert_equal "special", c["special key"].key
      assert_equal "again", c["special key"].key2

      e = assert_raises ArgumentError do
        c._ "special key"
      end
      assert_equal "provide missing block", e.message
    end

    test "cannot nest nil" do
      c = config.tap do |config|
        config.key = :foo
      end

      e = assert_raises NoMethodError do
        c.deep.deeper.key
      end
      assert_match(/NilClass/, e.message)
    end

    test "respond_to_missing?" do
      c = config.tap do |config|
        config.foo = :bar
      end

      assert_respond_to c, :foo
    end

    test "re-use already defined nested config" do
      c = config.tap do |config|
        config.users do |users|
          users.max = 23
        end
        config.users do |users|
          users.min = 5
        end
      end

      assert_equal 23, c.users.max
      assert_equal 5, c.users.min
    end

    context "subclass" do
      let(:subclassed_config) do
        Class.new(NestedConfig) do
          def foo?
            :bar!
          end
        end.new
      end

      test "has foo?" do
        assert_equal :bar!, subclassed_config.foo?
      end

      test "nests subclassed config" do
        c = subclassed_config.tap do |config|
          config.users do |users|
            users.max = 23
          end
        end

        assert_equal :bar!, c.users.foo?
      end
    end
  end
end
