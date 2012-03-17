# coding: utf-8

require 'redcarpet'
require 'pygments'
require 'coderay'
require 'digest/sha1'
require 'set'

module Retter
  module Renderers
    class CodeRayRenderer < Redcarpet::Render::HTML
      def block_code(code, lang)
        CodeRay.scan(code, lang ? lang.intern : :plain).div
      end
    end

    class PygmentsRenderer < Redcarpet::Render::HTML
      LANGUAGES = Set.new(Pygments.lexers.map {|_, l| l[:aliases] }.flatten)

      def block_code(code, lang)
        lang = LANGUAGES.include?(lang) ? lang : 'text'

        Pygments.highlight(code, lexer: lang, formatter: 'html', options: {encoding: 'utf-8'})
      end
    end
  end
end
