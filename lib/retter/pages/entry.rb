# coding: utf-8

module Retter
  class Pages::Entry
    include Page
    extend Configurable

    configurable :entry_layout_file

    attr_reader :entry

    def initialize(entry)
      super()
      @path_prefix = '../'
      @entry       = entry
      @title       = "#{entry.date} - #{config.title}"
    end

    def pathname
      Pages.entry_file(entry.date)
    end

    def part_layout_pathname
      entry_layout_file
    end

    def print
      part = Tilt.new(
        part_layout_pathname.to_path,
        ugly: true,
        filename: part_layout_pathname.to_path
      ).render(view_scope, entry: entry)

      print_with_layout part
    end
  end
end
