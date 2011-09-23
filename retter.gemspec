# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "retter/version"

Gem::Specification.new do |s|
  s.name        = "retter"
  s.version     = Retter::VERSION
  s.authors     = ["hibariya", "uzura29"]
  s.email       = ["celluloid.key@gmail.com"]
  s.homepage    = "https://github.com/hibariya/retter"
  s.summary     = %q{Flyweigh diary workflow}
  s.description = %q{Flyweigh diary workflow. ruby-1.9.2 or later is required.}

  #s.rubyforge_project = "retter"

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]

  s.add_runtime_dependency 'thor', ['>= 0.14.6']
  s.add_runtime_dependency 'builder', ['>= 3.0.0']
  s.add_runtime_dependency 'redcarpet', ['>= 2.0.0b3']
  s.add_runtime_dependency 'coderay', ['>= 0.9.8']
  s.add_runtime_dependency 'nokogiri', ['>= 1.5.0']
  s.add_runtime_dependency 'launchy', ['>= 2.0.5']
  s.add_runtime_dependency 'haml', ['>= 3.1.3']
  s.add_runtime_dependency 'bundler', ['>= 1.0']
  s.add_runtime_dependency 'grit', ['>= 2.4.1']

  s.add_development_dependency 'rake', ['>= 0.9.2']
  s.add_development_dependency 'ir_b', ['>= 1.4.0']
  s.add_development_dependency 'tapp', ['>= 1.1.0']
  s.add_development_dependency 'rspec', ['>= 2.6.0']
  s.add_development_dependency 'simplecov', ['>= 0.5.3']
end
