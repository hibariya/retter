# coding: utf-8

module Retter
  class Pages # XXX 名前が気に食わない
    autoload :Index,   'retter/pages/index'
    autoload :Profile, 'retter/pages/profile'
    autoload :Entries, 'retter/pages/entries'
    autoload :Feed,    'retter/pages/feed'
    autoload :Entry,   'retter/pages/entry'
    autoload :Article, 'retter/pages/article'

    extend Configurable
    include Site

    configurable :layouts_dir, :entries_dir, :allow_binding

    class << self
      def find_layout_path(name)
        detected = Dir.glob(layouts_dir.join("#{name}.*.*")).first

        Pathname.new(detected)
      end

      def layout_file
        @layout_file ||= find_layout_path('retter')
      end

      def entry_file(date)
        entries_dir.join date.strftime('%Y%m%d.html')
      end

      def entry_dir(date)
        entries_dir.join date.strftime('%Y%m%d')
      end
    end

    def initialize
      load_singleton_pages
    end

    def bind!
      print_entries

      @singleton_pages.each(&:print)
    end

    def print_entries
      entries.each do |entry|
        entry_page = Entry.new(entry)
        entry_page.print

        entry.articles.each do |article|
          article_page = Article.new(article)
          article_page.print
        end
      end
    end

    private

    def load_singleton_pages
      @singleton_pages = available_singleton_page_names.map {|name|
        Pages.const_get(name.capitalize).new
      }
    end

    def available_singleton_page_names
      availables = [:index]

      unless allow_binding == :none
        availables += allow_binding || [:profile, :entries, :feed]
      end

      availables.map(&:downcase).uniq
    end
  end
end
