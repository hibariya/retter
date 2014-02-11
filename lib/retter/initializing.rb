module Retter::Initializing
  extend ActiveSupport::Concern

  module ClassMethods
    # Usage:
    #  Retter.on_initialize do |config|
    #    initialize process
    #    -> { after initialize process (optional) }
    #  end
    def on_initialize(&block)
      call_initializers(block).tap do |after_initialize_hooks|
        after_initialize_hooks.each &:call
      end if initialized?

      initializers << block
    end

    private

    def process_initialize
      call_initializers.tap do |after_initialize_hooks|
        @initialized = true

        after_initialize_hooks.each &:call
      end
    end

    def initialized?; @initialized end

    def initializers
      @initializers ||= []
    end

    def call_initializers(procs = initializers)
      Array(procs).each.with_object([]) {|initialize_proc, after_procs|
        returned = initialize_proc.call(config)

        after_procs << returned if returned.respond_to?(:call)
      }
    end

    # should be overwrite
    def config; end
  end
end
