# coding: utf-8

class Retter::Pages::Archive
  include Retter::Page

  def pathname
    config.entries_file
  end

  def part_layout_pathname
    config.entries_layout_file
  end
end
