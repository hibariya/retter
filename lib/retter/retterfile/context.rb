require 'singleton'

module Retter
  class Retterfile
    class Context
      module ShortcutMethods
        %w(editor shell renderer title description url author disqus_shortname).each do |name|
          define_method name do |val = nil|
            config = Retter.config

            val ? config[name] = val : config[name]
          end
        end

        def after(name, sym = nil, &block)
          Retter.config.after name, sym, &block
        end
      end

      include Singleton
      include ShortcutMethods
      include Deprecated::Retterfile::Context

      def configure(options = {})
        config = Retter.config
        config.api_revision = Integer(options[:api_revision])
        config.extend Retter::Config::ConfigMethods

        yield config
      end
    end
  end
end
