# coding: utf-8

require 'redcarpet'
require 'pygments'
require 'coderay'
require 'set'

module Retter
  module Markdown
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

    extend Configurable

    configurable :renderer

    class << self
      def instance
        @instances ||= {}

        @instances[renderer.name] ||= Redcarpet::Markdown.new(
          renderer,
          autolink:            true,
          space_after_headers: true,
          fenced_code_blocks:  true,
          strikethrough:       true,
          superscript:         true,
          fenced_code_blocks:  true,
          tables:              true
        )
      end
    end
  end
end
