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

    def method_missing(name, *args, &block)
      if block
        config = self[name] ||= Config.new
        yield config
      else
        key = name.to_s.gsub(/=$/, '')
        if $& == '=' # setter
          self[key] = args.first
        else
          self[name]
        end
      end
    end
  end
end
