# coding: utf-8

module Retter::Stationery
  class << self
    def scan(path)
      entries = find_markup_files(path).map {|file|
        date = file.basename('.*').to_s
        mkup = File.open(file, &:read)
        Retter::Entry.new date: Date.parse(date), body: parser.render(mkup)
      }

      entries.sort_by(&:date).reverse
    end

    def find_markup_files(path)
      path = Pathname.new(path).realpath
      Dir.open(path, &:to_a).grep(/^\d{4}(?:0[1-9]|1[012])(?:0[1-9]|[12][0-9]|3[01])\.(md)$/).map {|f| path.join f }
    end

    def parser
      @parser ||= ::Redcarpet::Markdown.new(
        Renderer,
        autolink: true,
        space_after_headers: true,
        fenced_code_blocks: true,
        strikethrough: true,
        superscript: true,
        fenced_code_blocks: true,
        tables: true
      )
    end

    def previewer(config, date)
      Previewer.new config, date
    end

    def binder(config)
      Binder.new config
    end
  end
end

require 'retter/stationery/renderer'
require 'retter/stationery/view'
require 'retter/stationery/previewer'
require 'retter/stationery/binder'

