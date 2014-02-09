# coding: utf-8

lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)

require 'retter/version'

Gem::Specification.new do |spec|
  spec.name          = 'retter'
  spec.version       = Retter::VERSION
  spec.authors       = ['hibariya', 'uzura29']
  spec.email         = ['celluloid.key@gmail.com']
  spec.summary       = %q{A diary workflow}
  spec.description   = %q{A diary workflow for shell users.}
  spec.homepage      = 'https://github.com/hibariya/retter'
  spec.license       = 'MIT'

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ['lib']

  spec.required_ruby_version = '>= 1.9.1'

  spec.add_runtime_dependency 'coffee-rails',     '~> 4.0.1'
  spec.add_runtime_dependency 'haml-rails',       '~> 0.5.3'
  spec.add_runtime_dependency 'jquery-rails',     '~> 3.0.4'
  spec.add_runtime_dependency 'rails',            '~> 4.0.2'
  spec.add_runtime_dependency 'sass',             '~> 3.2.13' # NOTE: Avoid depending on listen.gem ~> 1.1.0
  spec.add_runtime_dependency 'sass-rails',       '~> 4.0.1'
  spec.add_runtime_dependency 'uglifier',         '>= 2.4.0'

  spec.add_runtime_dependency 'activesupport'
  spec.add_runtime_dependency 'chronic',          '~> 0.10.2'
  spec.add_runtime_dependency 'guard-livereload', '~> 2.1.1'
  spec.add_runtime_dependency 'launchy',          '~> 2.4.2'
  spec.add_runtime_dependency 'nokogiri',         '~> 1.6.1'
  spec.add_runtime_dependency 'rake',             '~> 10.1.1' # XXX: Avoid `WARN: Unresolved specs during Gem::Specification.reset: rake (>= 0.8.7)'
  spec.add_runtime_dependency 'rack-livereload',  '~> 0.3.15'
  spec.add_runtime_dependency 'redcarpet',        '~> 3.0.0'
  spec.add_runtime_dependency 'rouge',            '~> 1.3.2'
  spec.add_runtime_dependency 'thor',             '~> 0.18.1'
  spec.add_runtime_dependency 'ffi',              '~> 1.9.3' # Avoid `WARN: Unresolved specs during Gem::Specification.reset: ffi (>= 0.5.0)'

  spec.add_development_dependency 'bundler'
  spec.add_development_dependency 'coderay',     '~> 1.1.0'
  spec.add_development_dependency 'pygments.rb', '~> 0.5.4'
  spec.add_development_dependency 'rspec',       '~> 2.14.1'
end
