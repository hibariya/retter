require 'coderay'

module Retter
  module StaticSite
    class Markdown < Redcarpet::Markdown
      class CodeRayRenderer < Redcarpet::Render::HTML
        def block_code(code, lang)
          CodeRay.scan(code, lang ? lang.intern : :plain).div
        end
      end
    end
  end
end
