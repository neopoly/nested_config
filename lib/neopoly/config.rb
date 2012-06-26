module Neopoly
  class Config
    VERSION = "0.2.0"

    autoload :EvaluateOnce, 'neopoly/config/evaluate_once'

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
end
