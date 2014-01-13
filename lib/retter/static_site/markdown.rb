require 'redcarpet'
require 'rouge'
require 'rouge/lexer'
require 'rouge/plugins/redcarpet'

module Retter
  module StaticSite
    class Markdown < Redcarpet::Markdown
      autoload :PygmentsRenderer, 'retter/static_site/markdown/pygments_renderer'
      autoload :CodeRayRenderer,  'retter/static_site/markdown/code_ray_renderer'

      class Renderer < Redcarpet::Render::HTML
        include Rouge::Plugins::Redcarpet
      end

      class << self
        def new(renderer = Renderer, options = {})
          options.reverse_merge! autolink: true, space_after_headers: true, fenced_code_blocks: true, strikethrough: true, fenced_code_blocks: true, tables: true

          super(renderer, options)
        end
      end
    end
  end
end
