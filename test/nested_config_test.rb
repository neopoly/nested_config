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

    test "inspect retrives __hash__" do
      c = config.tap { |c| c.foo = :bar }
      assert_same c.inspect, c.__hash__
    end

    test "cannot use defined method names as keys" do
      c = config.tap do |c|
        c.object_id = :foo
        c.class     = :bar
      end
      refute_equal :foo, c.object_id
      refute_equal :bar, c.class
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

    test "sets arrays as value" do
      c = config.tap do |c|
        c.ary   = [ :foo, :bar ]
        c.ary2  = :foo, :bar
      end

      assert_equal [ :foo, :bar ], c.ary
      assert_equal [ :foo, :bar ], c.ary2
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

    test "respond_to?" do
      c = config.tap do |c|
        c.foo = :bar
      end

      assert_respond_to c, :foo
    end

    test "re-use already defined nested config" do
      c = config.tap do |c|
        c.users do |users|
          users.max = 23
        end
        c.users do |users|
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
        c = subclassed_config.tap do |c|
          c.users do |users|
            users.max = 23
          end
        end

        assert_equal :bar!, c.users.foo?
      end
    end

    context "clone" do
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

      test "deep" do
        clone = config.__clone__
        clone.nest.level = 23
        clone.nest.deep.level = 5

        assert_equal 1, config.nest.level
        assert_equal 2, config.nest.deep.level
      end

      test "cannot clone procs" do
        config.proc = proc {}
        assert_raises TypeError do
          config.__clone__
        end
      end
    end

    context "replace" do
      let(:config) do
        NestedConfig.new
      end

      test "replace with new raw hash" do
        config.__replace__ "string" => "value", :symbol => :value, "nested" => { :key => 1 }
        assert_equal "value", config.string
        assert_nil config.symbol
        assert_equal({ :key => 1 }, config.nested)
      end
    end
  end
end
