# coding: utf-8

module Retter
  class Pages # XXX 名前が気に食わない
    require 'retter/pages/index'
    require 'retter/pages/profile'
    require 'retter/pages/archive'
    require 'retter/pages/feed'
    require 'retter/pages/entry'
    require 'retter/pages/article'

    include Retter::Stationery

    attr_reader :index, :profile, :archive, :feed, :singleton_pages

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
