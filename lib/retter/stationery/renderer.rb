# coding: utf-8

module Retter::Stationery
  class Renderer < ::Redcarpet::Render::HTML
    def block_code(code, lang)
      ::CodeRay.scan(code, lang ? lang.intern : :plain).div
    end
  end
end
