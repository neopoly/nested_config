source "https://rubygems.org"

gemspec

if ENV['COVERAGE']
  group :test do
    gem 'simplecov', :require => false
    gem 'simplecov-rcov', :require => false
    gem 'codeclimate-test-reporter', :require => false
  end
end
