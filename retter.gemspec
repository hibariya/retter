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

    * DISQUS (comment system) support is now available.
      First, Add your `disqus_shortname` to Retterfile.

      in Retterfile:
        disqus_shortname 'your_disqus_shortname'

      Second, Edit templete and paste `render_disqus_comment_form`.

      in layouts/article.html.haml:
        #comments= render_disqus_comment_form

    * Filename is now specificable.
      Examples:
        $ retter edit today.md
        $ retter edit 20110101.md
        $ retter preview 20110101.md

    -- Thanks for flying Retter :-> --
  EOM

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]

  s.add_runtime_dependency 'thor', ['>= 0.14.6']
  s.add_runtime_dependency 'builder', ['>= 3.0.0']
  s.add_runtime_dependency 'redcarpet', ['>= 2.0.0b3']
  s.add_runtime_dependency 'coderay', ['>= 0.9.8']
  s.add_runtime_dependency 'pygments.rb', ['>= 0.2.7']
  s.add_runtime_dependency 'nokogiri', ['>= 1.5.0']
  s.add_runtime_dependency 'launchy', ['>= 2.0.5']
  s.add_runtime_dependency 'haml', ['>= 3.1.3']
  s.add_runtime_dependency 'bundler', ['>= 1.0']
  s.add_runtime_dependency 'grit', ['>= 2.4.1']
  s.add_runtime_dependency 'activesupport', ['>= 3.1.0']

  # XXX for ActiveSupport dependency
  s.add_runtime_dependency 'rack', ['>= 1.4.1']
  s.add_runtime_dependency 'i18n', ['>= 0.6.0']

  s.add_development_dependency 'rake', ['>= 0.9.2']
  s.add_development_dependency 'ir_b', ['>= 1.4.0']
  s.add_development_dependency 'tapp', ['>= 1.1.0']
  s.add_development_dependency 'rspec', ['>= 2.6.0']
  s.add_development_dependency 'fuubar', ['>= 0.0.6']
  s.add_development_dependency 'simplecov', ['>= 0.5.3']
end
