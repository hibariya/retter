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

      attribute :position, default: 0
      attribute :entry
      attribute :title
      attribute :body

      def id
        "#{entry.id}#{relative_code}"
      end

      def relative_code
        "a#{position}"
      end

      # XXX: to_param should returns identifiable value
      alias to_param relative_code

      include Deprecated::Entry::Article
    end
  end
end
