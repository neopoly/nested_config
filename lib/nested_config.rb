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

  def __clone__
    Marshal.load(Marshal.dump(self))
  end

  # Replaces the internal hash with raw +hash+.
  # This method is useful when restoring hash config.
  #
  # See WithConfig
  def __replace__(hash)
    @hash = hash
  end

  def inspect
    @hash
  end

  def method_missing(name, *args)
    if block_given?
      config = self[name] ||= self.class.new
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

  def respond_to?(name, include_private=false)
    __hash__.key?(name.to_s) || super
  end
end
