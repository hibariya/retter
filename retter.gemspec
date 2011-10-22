# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "retter/version"

Gem::Specification.new do |s|
  s.name        = "retter"
  s.version     = Retter::VERSION
  s.authors     = ["hibariya", "uzura29"]
  s.email       = ["celluloid.key@gmail.com"]
  s.homepage    = "https://github.com/hibariya/retter"
  s.summary     = %q{Flyweight diary workflow}
  s.description = %q{Flyweight diary workflow. ruby-1.9.2 or later is required.}


  s.post_install_message = <<-EOM
    **Important** Some features were added or updated.

    * Article has Permlink in retter-0.1.0 or later.
      If error occured, try overwrite templates by `retter gen $RETTER_HOME`. (overwrite layouts/*.html.haml)

    * Relative date is now available in `--date` option.
      Examples:
        $ retter edit yesterday
        $ retter edit today
        $ retter edit tomorrow
        $ retter preview 2.days.ago

    * `--key` option is now available in edit (and preview).
      Examples:
        $ retter list
        [e0] 2011-10-12  article3, article4
        [e1] 2011-10-10  article1, article2
        $ retter edit --key e0
          ... or ...
        $ retter edit e0

    * Default date format has changed.
      2011/01/01 -> 2011-01-01

    -- Thanks for flying Retter :-> --
  EOM

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
  s.add_runtime_dependency 'activesupport', ['>= 3.1.0']
  s.add_runtime_dependency 'i18n', ['>= 0.6.0']

  s.add_development_dependency 'rake', ['>= 0.9.2']
  s.add_development_dependency 'ir_b', ['>= 1.4.0']
  s.add_development_dependency 'tapp', ['>= 1.1.0']
  s.add_development_dependency 'rspec', ['>= 2.6.0']
  s.add_development_dependency 'fuubar', ['>= 0.0.6']
  s.add_development_dependency 'simplecov', ['>= 0.5.3']
end
