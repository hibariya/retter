# -*- encoding: utf-8 -*-
$:.push File.expand_path('../lib', __FILE__)
require 'retter/version'

Gem::Specification.new do |gem|
  gem.name        = 'retter'
  gem.version     = Retter::VERSION
  gem.authors     = ['hibariya', 'uzura29']
  gem.email       = ['celluloid.key@gmail.com']
  gem.homepage    = 'https://github.com/hibariya/retter'
  gem.summary     = %q{Flyweight diary workflow}
  gem.description = %q{Flyweight diary workflow. ruby-1.9.2 or later is required.}

  gem.files         = `git ls-files`.split("\n")
  gem.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  gem.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  gem.require_paths = ['lib']

  gem.required_ruby_version = '>= 1.9.1'

  gem.add_runtime_dependency 'thor',          ['~> 0.16.0']
  gem.add_runtime_dependency 'builder',       ['~> 3.1.3']
  gem.add_runtime_dependency 'redcarpet',     ['~> 2.1.1']
  gem.add_runtime_dependency 'coderay',       ['~> 1.0.7']
  gem.add_runtime_dependency 'pygments.rb',   ['~> 0.2.13']
  gem.add_runtime_dependency 'nokogiri',      ['~> 1.5.5']
  gem.add_runtime_dependency 'launchy',       ['~> 2.1.2']
  gem.add_runtime_dependency 'haml',          ['~> 3.1.7']
  gem.add_runtime_dependency 'tilt',          ['~> 1.3.3']
  gem.add_runtime_dependency 'bundler',       ['~> 1.2.1']
  gem.add_runtime_dependency 'grit',          ['~> 2.5.0']
  gem.add_runtime_dependency 'chronic',       ['~> 0.8.0']
  gem.add_runtime_dependency 'activesupport', ['~> 3.2.8']

  # XXX for ActiveSupport dependencies
  gem.add_runtime_dependency 'rack',          ['~> 1.4.1']
  gem.add_runtime_dependency 'i18n',          ['~> 0.6.1']

  gem.add_development_dependency 'rake',      ['~> 0.9.2']
  gem.add_development_dependency 'ir_b',      ['~> 1.5.0']
  gem.add_development_dependency 'tapp',      ['~> 1.4.0']
  gem.add_development_dependency 'rspec',     ['~> 2.11.0']
  gem.add_development_dependency 'fuubar',    ['~> 1.0.0']
  gem.add_development_dependency 'simplecov', ['~> 0.6.4']
  gem.add_development_dependency 'delorean',  ['~> 2.0.0']
end
