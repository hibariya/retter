require 'set'

module Retter
  module CLI
    module Hooks
      extend ActiveSupport::Concern

      module ClassMethods
        mattr_accessor :callbacks

        def hookable_name(*names)
          names.each do |name|
            hookable_names << name
          end
        end

        def hookable_names
          @hookable_names ||= Set.new([name.demodulize.underscore.intern])
        end

        def call_hooks(hook_point = :after, context = CLI::Command.new)
          return unless callbacks

          hookable_names.each do |name|
            case callback = callbacks["#{hook_point}_#{name}".intern]
            when Proc
              context.instance_eval &callback
            when Symbol, String
              context.invoke callback
            else
              # noop
            end
          end
        end

        Retter.on_initialize do |config|
          self.callbacks = config.callbacks
        end
      end
    end
  end
end
