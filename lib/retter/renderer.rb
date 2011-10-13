# coding: utf-8

module Retter
  class Renderer < ::Redcarpet::Render::HTML
    def block_code(code, lang)
      ::CodeRay.scan(code, lang ? lang.intern : :plain).div
    end
  end
end
