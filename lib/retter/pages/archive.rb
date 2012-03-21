# coding: utf-8

module Retter
  class Pages::Archive
    include Retter::Page
    extend Configurable

    configurable :entries_file, :entries_layout_file

    def pathname
      entries_file
    end

    def part_layout_pathname
      entries_layout_file
    end
  end
end
