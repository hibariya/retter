module Retter
  module StaticSite
    autoload :App,           'retter/static_site/app'
    autoload :CLI,           'retter/static_site/cli'
    autoload :Builder,       'retter/static_site/builder'
    autoload :Markdown,      'retter/static_site/markdown'
    autoload :MarkdownEntry, 'retter/static_site/markdown_entry'
    autoload :Repository,    'retter/static_site/repository'

    class << self
      def install
        return false if @installed

        {
          MarkdownEntry            => Retter::Entry,
          StaticSite::CLI::Command => Retter::CLI::Command
        }.each do |src, dest|
          dest.__send__ :include, src
        end

        @installed = true
      end
    end

    Retter.on_initialize do |config|
      config.source_branch  ||= 'master'
      config.publish_branch ||= 'master'

      if root = config.root
        config.build_path  ||= root.join('tmp/_build')
        config.source_path ||= root.join('source')
      end
    end
  end
end
