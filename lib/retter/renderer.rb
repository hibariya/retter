# coding: utf-8

require 'albino'

module Retter
  module Renderers
    class CodeRayRenderer < Redcarpet::Render::HTML
      def block_code(code, lang)
        CodeRay.scan(code, lang ? lang.intern : :plain).div
      end
    end

    class PygmentsRenderer < Redcarpet::Render::HTML
      def block_code(code, lang)
        Albino.colorize(code, (lang || 'text'))
      end
    end
  end
end
