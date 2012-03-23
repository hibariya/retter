# coding: utf-8

module Retter
  class Pages::Profile
    include Page

    def pathname
      config.retter_home.join('profile.html')
    end

    def part_layout_pathname
      Pages.find_layout_path('profile')
    end
  end
end
