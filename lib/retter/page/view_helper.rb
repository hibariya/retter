# coding: utf-8

module Retter::Page
  module ViewHelper
    include Retter::Stationery

    def entry_path(*args)
      case args.first
      when Date, Time
        date, id = *args
        date.strftime('/entries/%Y%m%d.html') + (id ? "##{id}" : '')
      when Retter::Entry
        entry = args.first
        entry_path(entry.date)
      else
        raise TypeError, "wrong argument type #{args.first.class} (expected Date, Time or Retter::Entry)"
      end
    end

    def article_path(*args)
      case args.first
      when Date, Time
        date, id = *args
        date.strftime("/entries/%Y%m%d/#{id}.html")
      when Retter::Entry::Article
        article = args.first
        article_path(article.entry.date, article.id)
      else
        raise TypeError, "wrong argument type #{args.first.class} (expected Date, Time or Retter::Entry::Article)"
      end
    end
  end
end
