# nested_config

[<img src="http://img.shields.io/travis/neopoly/nested_config.svg" alt="Build
Status" />](http://travis-ci.org/neopoly/nested_config) [<img
src="http://img.shields.io/gem/v/nested_config.svg" alt="Gem Version"
/>](http://rubygems.org/gems/nested_config) [<img
src="http://img.shields.io/codeclimate/github/neopoly/nested_config.svg"
/>](https://codeclimate.com/github/neopoly/nested_config) [<img
src="http://inch-ci.org/github/neopoly/nested_config.svg?branch=master"
alt="Inline docs" />](http://inch-ci.org/github/neopoly/nested_config)

Simple, static, nested application configuration

[Gem](https://rubygems.org/gems/nested_config) |
[Source](https://github.com/neopoly/nested_config) |
[Documentation](http://rubydoc.info/github/neopoly/nested_config/master/file/R
EADME.rdoc)

## Usage

```ruby
require 'nested_config'

class MyApp
  def self.configure
    yield config
  end

  def self.config
    @config ||= MyConfig.new
  end

  class MyConfig < NestedConfig
  end
end
```

### Basic

```ruby
MyApp.configure do |config|
  config.coins = 1000
  config.user do |user|
    user.max = 5
  end
  config.queue do |queue|
    queue.workers do |workers|
      workers.max = 2
      workers.timeout = 60.seconds
    end
  end
end

MyApp.config.coins # => 1000
MyApp.config.queue.workers.timeout # => 60
```

### EvaluateOnce

With the module `EvaluateOnce` you can define config value which will be
evaluated lazily. Once.

```ruby
class MyConfig
  include NestedConfig::EvaluateOnce
end

MyApp.configure do |config|
  config.country_list = proc { Country.all }
end

MyApp.config.country_list # => [List of countries]
MyApp.config.country_list # => [List of countries] (cached)
```

The initial access to key `country_list` calls (via `call` method) the proc
and replaces the value. Subsequent calls just fetch the replaced value.

### Modifying config using NestedConfig::WithConfig

Values of NestedConfig can be temporalily modified.

This can be used in tests modifying a global application config inside a
block:

```ruby
require 'nested_config/with_config'

class MyCase < MiniTest::TestCase
  include NestedConfig::WithConfig

  def app_config
    MyApp.config # global
  end
end

class SomeCase < MyCase
  def setup
    app_config.tap do |config|
      config.coins = 1000
      config.queue do |queue|
        queue.workers do |workers|
          workers.max = 5
        end
      end
    end
  end

  def test_with_basic_value
    with_config(app_config) do |config|
      config.coins = 500
    end
    # global config reset to previous config
  end

  def test_queue_with_changed_workers
    with_config(app_config, :queue, :workers) do |workers|
      workers.max = 1
      # do stuff with modified config max value
    end
    # global config reset to previous config
  end
end
```

### Key names

**Note**: NestedConfig is not a blank slate so you CANNOT use defined method
names as keys like `object_id`.

## Installation

    gem install nested_config

## Test

    rake test
    COVERAGE=1 bundle exec rake test

## TODO

*   Make NestedConfig a blank slate


## Release

    edit lib/nested_config/version.rb
    rake release

