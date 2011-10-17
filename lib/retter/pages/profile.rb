# coding: utf-8

class Retter::Pages::Profile
  include Retter::Page

  def pathname
    config.profile_file
  end

  def part_layout_pathname
    config.profile_layout_file
  end
end
