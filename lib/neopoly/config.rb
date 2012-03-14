module Neopoly
  class Config
    VERSION = "0.0.1"

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

    def method_missing(name, arg=nil)
      if block_given?
        config = self[name] ||= self.class.new
        yield config
      else
        key = name.to_s.gsub(/=$/, '')
        if $& == '='
          self[key] = arg
        else
          self[name]
        end
      end
    end

    def respond_to?(name, include_private=false)
      __hash__.key?(name.to_s) || super
    end
  end
end
