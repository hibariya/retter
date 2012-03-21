# coding: utf-8

module Retter
  class Pages # XXX 名前が気に食わない
    autoload :Index,   'retter/pages/index'
    autoload :Profile, 'retter/pages/profile'
    autoload :Archive, 'retter/pages/archive'
    autoload :Feed,    'retter/pages/feed'
    autoload :Entry,   'retter/pages/entry'
    autoload :Article, 'retter/pages/article'

    include Retter::Stationery

    extend Configurable

    configurable :layouts_dir, :layout_file, :entries_dir

    attr_reader :index, :profile, :archive, :feed, :singleton_pages

    class << self
      def entry_file(date)
        entries_dir.join date.strftime('%Y%m%d.html')
      end

      def entry_dir(date)
        entries_dir.join date.strftime('%Y%m%d')
      end
    end

    def initialize
      @singleton_pages = [Index, Profile, Archive, Feed].map(&:new)
      @index, @profile, @archive, @feed = *singleton_pages
    end

    def bind!
      print_entries

      singleton_pages.each(&:print)
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
  end
end
