# coding: utf-8

module Retter
  class Preprint
    include Retter::Page

    def pathname
      config.retter_home.join '.preview.html'
    end

    def part_layout_pathname
      Pages::Entry.entry_layout_file
    end

    def print(entry)
      part = Tilt.new(
        part_layout_pathname.to_path,
        ugly: true,
        filename: part_layout_pathname.to_path
      ).render(view_scope, entry: entry)

      print_with_layout part
    end
  end
end
