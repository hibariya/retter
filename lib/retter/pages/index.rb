# coding: utf-8

module Retter
  class Pages::Index
    include Page

    def pathname
      config.retter_home.join('index.html')
    end

    def part_layout_pathname
      Pages.find_layout_path('index')
    end
  end
end
