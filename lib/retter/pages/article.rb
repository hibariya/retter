# coding: utf-8

module Retter
  class Pages::Article
    include Page

    attr_reader :article

    def initialize(article)
      super()
      @path_prefix = '../../'
      @article     = article
      @title       = "#{article.title} - #{config.title}"
    end

    def pathname
      Pages.entry_dir(article.entry.date).join("#{article.id}.html")
    end

    def part_layout_pathname
      Pages.find_layout_path('article')
    end

    def print
      options = {entry: article.entry, article: article}
      part = Tilt.new(
        part_layout_pathname.to_path,
        ugly: true,
        filename: part_layout_pathname.to_path
      ).render(view_scope, options)

      mkdir
      print_with_layout part
    end

    def mkdir
      entry_dir = Pages.entry_dir(article.entry.date)
      entry_dir.mkdir unless entry_dir.directory?
    end
  end
end
