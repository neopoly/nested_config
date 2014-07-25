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
    backup = Marshal.load(Marshal.dump(@hash))
    yield(self)
  ensure
    @hash = backup if backup
  end

  def inspect
    @hash
  end

  def method_missing(name, *args, &block)
    if nested_config?(&block)
      evaluate_nested_config name, &block
    elsif assigment?(name)
      assign_value name, *args
    elsif predicate?(name)
      has_value?(name, *args)
    else
      retrieve_value name, *args
    end
  end

  def respond_to?(name, include_private=false)
    __hash__.key?(name.to_s) || super
  end

  private

  def nested_config?(&block)
    !block.nil?
  end

  def assigment?(name)
    !name.match(/.*=$/).nil?
  end

  def predicate?(name)
    !name.match(/.*\?/).nil?
  end

  def evaluate_nested_config(scope_name, &scope)
    config = self[scope_name] ||= self.class.new
    scope.call config
  end

  def assign_value(name, *args)
    key = name.to_s.gsub(/=$/, '')
    self[key] = args.first
  end

  def has_value?(name, *args)
    key = name.to_s.gsub(/\?$/, '')
    respond_to? key
  end

  def retrieve_value(name, *args)
    self[name, *args]
  end
end
