require 'nested_config/version'

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

  def __with_cloned__
    backup = ::Marshal.load(::Marshal.dump(@hash))
    yield self
  ensure
    @hash = backup
  end

  def __new__
    (class << self; self; end).superclass.new
  end

  def tap
    yield self
    self
  end

  def inspect
    @hash
  end

  def method_missing(name, *args, &block)
    if block
      config = self[name] ||= __new__
      yield config
    else
      key = name.to_s.gsub(/=$/, '')
      if $& == '='
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
