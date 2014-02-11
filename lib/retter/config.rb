module Retter
  module Config
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
  end
end
