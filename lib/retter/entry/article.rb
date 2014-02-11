module Retter
  class Entry
    class Article
      class << self
        def all
          Entry.all.flat_map(&:articles)
        end
      end

      include ModelBase
      include Pagination

      attr_reader :index, :title, :body
      attr_reader :entry

      def initialize(attrs = {})
        @index, @title, @body, @entry = *attrs.values_at(:index, :title, :body, :entry)

        @index ||= 0
      end

      def id
        "#{entry.id}#{relative_code}"
      end

      def relative_code
        "a#{index}"
      end

      # XXX: to_param should returns identifiable value
      alias to_param relative_code

      include Deprecated::Entry::Article
    end
  end
end
