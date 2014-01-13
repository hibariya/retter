require 'singleton'

module Retter
  class Retterfile
    class Context
      include Singleton
      include Deprecated::Retterfile::Context

      def configure(options = {})
        config = Retter.config
        config.api_revision = Integer(options[:api_revision])

        yield config
      end
    end
  end
end
