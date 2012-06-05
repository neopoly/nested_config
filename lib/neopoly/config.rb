module Neopoly
  class Config
    VERSION = "0.1.0"

    autoload :EvaluateOnce, 'neopoly/config/evaluate_once'

    def initialize
      @hash = {}
    end

    def [](name)
      @hash[name.to_s]
    end

    def []=(name, value)
      @hash[name.to_s] = value
    end

    def __hash__
      @hash
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
          __set__(key, args.first)
        else
          __get__(key, *args)
        end
      end
    end

    def respond_to?(name, include_private=false)
      __hash__.key?(name.to_s) || super
    end

    protected

    # Set hook
    def __set__(key, arg)
      self[key] = arg
    end

    # Get hook
    def __get__(key, *args)
      self[key]
    end
  end
end
