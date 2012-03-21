# coding: utf-8

module Retter
  class Pages::Index
    include Retter::Page
    extend Configurable

    configurable :index_file, :index_layout_file

    def pathname
      index_file
    end

    def part_layout_pathname
      index_layout_file
    end
  end
end
