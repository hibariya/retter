require 'active_attr'
require 'active_model'
require 'date'
require 'time'

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

      def find_or_build(keyword = nil)
        if entry = find_by_keyword(keyword)
          entry
        elsif date = Utils.parse_date(keyword)
          Entry.new(date: date)
        else
          if today_entry = find(Date.today)
            today_entry
          else
            Entry.new
          end
        end
      end
    end

    extend FindMethods
    extend SortMethods

    include ModelBase
    include Pagination

    attribute :source_path
    attribute :date
    attribute :lede
    attribute :articles, default: []

    def date_as_time
      return unless date?

      date.to_time.getutc
    end

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
