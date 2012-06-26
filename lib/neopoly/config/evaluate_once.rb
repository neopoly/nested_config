module Neopoly
  class Config
    # Evaluates a config value once replacing the original value
    # if the value responds to method +call+.
    #
    # == Example
    #
    #   class MyConfig < Neopoly::Config
    #     include Neopoly::Config::EvaluateOnce
    #   end
    #
    #   config = MyConfig.new
    #   config.startup_time = proc { Time.now }
    #   config.env = proc { |env| env.to_s.upcase }
    #
    #   config.startup_time # => 2012-06-05 15:57:36 +0200
    #   config.startup_time # => 2012-06-05 15:57:36 +0200
    #
    #   config.env(:development) # => DEVELOPMENT
    #   config.env               # => DEVELOPMENT
    module EvaluateOnce
      def [](key, *args)
        value = super
        if value.respond_to?(:call)
          self[key] = value.call(*args)
        else
          value
        end
      end
    end
  end
end
