require 'set'

module Retter
  module Deprecated
    class << self
      def removed_warn(name, alternate = nil, location = caller[1])
        warn_once build_warn(name, 'removed', alternate, location)
      end

      def warn(name, alternate = nil, location = caller[1])
        warn_once build_warn(name, 'deprecated', alternate, location)
      end

      private

      def build_warn(name, cause, alternate, location)
        message =  "WARNING: #{location} `#{name}' is #{cause}."
        message << " Please use `#{alternate}' instead of `#{name}'." if alternate

        message
      end

      def warn_once(message)
        return if shown.include?(message)

        Kernel.warn message
        shown << message
      end

      def shown
        @shown ||= Set.new
      end
    end

    module Retter
      extend ActiveSupport::Concern

      DEPRECATED_CONSTANTS = {
        Markdown: 'Retter::StaticSite::Markdown'
      }

      module ClassMethods
        def const_missing(name)
          return super unless DEPRECATED_CONSTANTS.keys.include?(name)

          right_name = DEPRECATED_CONSTANTS[name]
          Deprecated.warn "Retter::#{name}", right_name

          right_name.constantize
        end
      end
    end

    module Site
      extend ActiveSupport::Concern

      included do
        module Site
          extend self

          %w(home title description url author load reset! entries config).each do |name|
            define_method name do |*args|
              Deprecated.removed_warn %(Site##{name})
            end
          end
        end
      end
    end

    module Entry
      extend ActiveSupport::Concern

      included do
        alias_method :path, :source_path
      end

      module Article
        def to_s
          Deprecated.warn 'Article#to_s', 'Article#body'
          body.html_safe
        end

        def actual?
          Deprecated.removed_warn 'Article#actual?'
          true
        end
      end
    end

    module CLI
      module Build
        extend ActiveSupport::Concern

        included do
          hookable_name :bind, :rebind, :commit
        end
      end

      module Command
        extend ActiveSupport::Concern

        included do
          desc :rebind, '[DEPRECATED]', hide: true
          method_options silent: :boolean
          def rebind
            Deprecated.warn :rebind, :build, '(command)'

            invoke :build
          end

          desc :bind, '[DEPRECATED]', hide: true
          method_options silent: :boolean
          def bind
            Deprecated.warn :bind, :build, '(command)'

            invoke :build
          end

          desc :commit, '[DEPRECATED]', hide: true
          method_options silent: :boolean
          def commit
            Deprecated.removed_warn :commit, :build, '(command)'
          end

          desc :home, '[DEPRECATED]', hide: true
          def home
            Deprecated.removed_warn :home, nil, '(command)'
          end

          desc :usage, '[DEPRECATED]', hide: true
          def usage(*args)
            Deprecated.removed_warn :usage, :help, '(command)'
          end

          desc :open, '[DEPRECATED]', hide: true
          def open(*args)
            Deprecated.warn :open, 'preview /', '(command)'

            invoke :preview, '/'
          end

          desc :clean, '[DEPRECATED]', hide: true
          def clean(*args)
            Deprecated.removed_warn :clean, nil, '(command)'
          end
        end
      end
    end

    module Retterfile
      module Context
        def config
          ::Retter.config
        end

        %w(editor shell renderer title description url author disqus_shortname).each do |name|
          define_method name do |val = nil|
            val ? config[name] = val : config[name]
          end
        end

        %w(markup cache allow_binding home retter_home layouts_dir entries_dir retters_dir wip_file).each do |name|
          define_method name do |val = nil|
            Deprecated.removed_warn name, nil, 'Rettefile'
          end
        end

        def after(name, sym = nil, &block)
          config.after name, sym, &block
        end
      end
    end
  end
end
