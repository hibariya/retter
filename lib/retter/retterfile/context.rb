require 'singleton'

module Retter
  class Retterfile
    class Context
      module ConfigMethods
        class << self
          def extended(object)
            object.callbacks = ActiveSupport::OrderedOptions.new
          end
        end

        def after(name, sym = nil, &block)
          key = "after_#{name}".intern

          if callback = sym || block
            callbacks[key] = callback
          else
            callbacks[key]
          end
        end

        def publisher(&block)
          block ? self[:publisher] = block : self[:publisher]
        end
      end

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
        config.extend ConfigMethods

        yield config
      end
    end
  end
end
