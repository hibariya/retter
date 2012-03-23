# coding: utf-8

module Retter
  class Pages::Entries
    include Page

    def pathname
      config.retter_home.join('entries.html')
    end

    def part_layout_pathname
      Pages.find_layout_path('entries')
    end
  end
end
