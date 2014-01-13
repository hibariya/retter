module Retter
  class Entry
    class Article
      class << self
        def all
          Entry.all.map(&:articles).flatten
        end
      end

      extend ActiveModel::Naming

      include Pagination

      attr_reader :id, :title, :body
      attr_reader :entry

      def initialize(attrs = {})
        @id, @title, @body, @entry = *attrs.values_at(:id, :title, :body, :entry)
      end

      def to_param
        id
      end

      include Deprecated::Entry::Article
    end
  end
end
