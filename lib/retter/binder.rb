# coding: utf-8

module Retter
  class Binder
    extend Configurable

    configurable :allow_binding

    def initialize(entries)
      @entries         = entries
      @singleton_pages = find_singleton_pages
    end

    def bind!
      bind_entries

      @singleton_pages.each(&:bind)
    end

    def bind_entries
      @entries.each do |entry|
        entry_page = Page::Entry.new(entry)
        entry_page.bind

        entry.articles.each do |article|
          article_page = Page::Article.new(article)
          article_page.bind
        end
      end
    end

    private

    def find_singleton_pages
      available_singleton_page_names.map {|name|
        Page.const_get(name.capitalize).new
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
