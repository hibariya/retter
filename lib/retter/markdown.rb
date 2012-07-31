# coding: utf-8

require 'redcarpet'

module Retter
  module Markdown
    autoload :CodeRayRenderer,  'retter/markdown/code_ray_renderer'
    autoload :PygmentsRenderer, 'retter/markdown/pygments_renderer'

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
