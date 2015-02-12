source "http://rubygems.org"

gemspec

if ENV['COVERAGE']
  group :test do
    gem 'simplecov',        :require => false
    gem 'simplecov-rcov',   :require => false
  end
end

if ENV['CODECLIMATE_REPO_TOKEN']
  gem "codeclimate-test-reporter", :group => :test, :require => nil
end
