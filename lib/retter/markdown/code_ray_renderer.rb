require 'coderay'

module Retter
  module Markdown
    class CodeRayRenderer < Redcarpet::Render::HTML
      def block_code(code, lang)
        CodeRay.scan(code, lang ? lang.intern : :plain).div
      end
    end
  end
end
