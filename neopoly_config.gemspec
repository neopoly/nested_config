# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "neopoly_config"

Gem::Specification.new do |s|
  s.name        = "neopoly_config"
  s.version     = Neopoly::Config::VERSION
  s.authors     = ["Peter Suschlik"]
  s.email       = ["ps@neopoly.de"]
  s.homepage    = "https://gemdocs.neopoly.com"
  s.summary     = %q{Simple, static, nested config}
  s.description = %q{}

  s.rubyforge_project = "neopoly_config"

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]

  s.add_development_dependency "rake"
  s.add_development_dependency "minitest"
end
