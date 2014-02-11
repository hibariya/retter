require 'active_model'

module Retter
  class Entry
    autoload :Article,     'retter/entry/article'
    autoload :FindMethods, 'retter/entry/find_methods'
    autoload :ModelBase,   'retter/entry/model_base'
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

    extend FindMethods
    extend SortMethods

    include ModelBase
    include Pagination

    attr_reader :source_path
    attr_reader :date, :lede
    attr_reader :articles

    def modified_at
      source_path.try(:mtime)
    end

    def id
      date.strftime('%Y%m%d')
    end

    alias to_param id

    include Deprecated::Entry
  end
end
