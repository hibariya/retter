require 'pygments'
require 'set'

module Retter
  module StaticSite
    class Markdown < Redcarpet::Markdown
      class PygmentsRenderer < Redcarpet::Render::HTML
        LANGUAGES = Set.new(Pygments.lexers.map {|_, l| l[:aliases] }.flatten)

        def block_code(code, lang)
          lang = LANGUAGES.include?(lang) ? lang : 'text'

          Pygments.highlight(code, lexer: lang, formatter: 'html', options: {encoding: 'utf-8'})
        end
      end
    end
  end
end
