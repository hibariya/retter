# coding: utf-8

class Retter::Pages::Article
  include Retter::Page

  attr_reader :article

  def initialize(article)
    super()
    @path_prefix = '../../'
    @article     = article
    @title       = "#{article.title} - #{config.title}"
  end

  def pathname
    config.entry_dir(article.entry.date).join("#{article.id}.html")
  end

  def part_layout_pathname
    config.article_layout_file
  end

  def print
    options = {entry: article.entry, article: article}
    part = Haml::Engine.new(
      part_layout_pathname.read,
      ugly: true,
      filename: part_layout_pathname.to_s
    ).render(view_scope, options)

    mkdir
    print_with_layout part
  end

  def mkdir
    entry_dir = config.entry_dir(article.entry.date)
    entry_dir.mkdir unless entry_dir.directory?
  end
end
