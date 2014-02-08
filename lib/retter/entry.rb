require 'active_model'

module Retter
  class Entry
    autoload :Article,     'retter/entry/article'
    autoload :FindMethods, 'retter/entry/find_methods'
    autoload :Pagination,  'retter/entry/pagination'
    autoload :SortMethods, 'retter/entry/sort_methods'
    autoload :Utils,       'retter/entry/utils'

    class << self
      attr_writer :all

      def all
        @all ||= []
      end

      def generate_entry_path(keyword = nil)
        super
      end
    end

    extend ActiveModel::Naming
    extend FindMethods
    extend SortMethods

    include Pagination

    attr_reader :source_path
    attr_reader :date, :lede
    attr_reader :articles

    def to_param
      date.strftime('%Y%m%d')
    end

    def modified_at
      source_path.try(:mtime)
    end

    include Deprecated::Entry
  end
end
