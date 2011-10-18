# coding: utf-8

class Retter::Pages::Index
  include Retter::Page

  def pathname
    config.index_file
  end

  def part_layout_pathname
    config.index_layout_file
  end
end
