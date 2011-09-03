# coding: utf-8

module Retter::Stationery
  class Renderer < ::Redcarpet::Render::HTML
    def block_code(code, lang)
      ::CodeRay.scan(code, lang ? lang.intern : :plain).div#.div(line_numbers: :table)
    end
  end
end
