# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "nested_config/version"

Gem::Specification.new do |s|
  s.name        = "nested_config"
  s.version     = NestedConfig::VERSION
  s.authors     = ["Peter Suschlik"]
  s.email       = ["ps@neopoly.de"]
  s.homepage    = "https://rubygems.org/gems/nested_config"
  s.summary     = %q{Simple, static, nested config}
  s.description = %q{}

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]

  s.add_development_dependency "rake"
  s.add_development_dependency "minitest"
  s.add_development_dependency "rdoc"
end
