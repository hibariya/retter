# coding: utf-8

module Retter
  class Pages::Profile
    include Retter::Page
    extend Configurable

    configurable :profile_layout_file, :profile_file

    def pathname
      profile_file
    end

    def part_layout_pathname
      profile_layout_file
    end
  end
end
