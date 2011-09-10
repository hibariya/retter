# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "retter/version"

Gem::Specification.new do |s|
  s.name        = "retter"
  s.version     = Retter::VERSION
  s.authors     = ["hibariya"]
  s.email       = ["celluloid.key@gmail.com"]
  s.homepage    = "https://github.com/hibariya/retter"
  s.summary     = %q{Lightweight diary workflow}
  s.description = %q{Lightweight diary workflow}

  #s.rubyforge_project = "retter"

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]

  s.add_runtime_dependency 'thor'
  s.add_runtime_dependency 'builder'
  s.add_runtime_dependency 'redcarpet', ['>= 2.0.0b3']
  s.add_runtime_dependency 'coderay'
  s.add_runtime_dependency 'nokogiri'
  s.add_runtime_dependency 'launchy'
  s.add_runtime_dependency 'haml'
  s.add_runtime_dependency 'bundler'
  s.add_runtime_dependency 'grit'

  s.add_development_dependency 'ir_b'
  s.add_development_dependency 'tapp'
  s.add_development_dependency 'rspec'
  s.add_development_dependency 'simplecov'
end
