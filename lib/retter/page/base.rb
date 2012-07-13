# coding: utf-8

module Retter
  module Page
    module Base
      class ViewContext
        include ViewHelper
      end

      include Site

      attr_reader :path_prefix, :title

      def initialize
        @path_prefix = './'
        @title       = config.title
      end

      def bind
        context = ViewContext.new
        part    = Tilt.new(
          template_path.to_path,
          ugly: true,
          filename: template_path.to_path
        ).render(context)

        print part
      end

      def path
        raise NotImplementedError
      end

      def template_path
        raise NotImplementedError
      end

      private

      def print(content)
        context    = ViewContext.new
        draft      = layout_renderer.render(context, content: content, title: title)
        path_fixed = fix_path(draft, path_prefix)

        path.open('w') {|f| f.puts path_fixed }
      end

      def layout_renderer
        path = Page.layout_path.to_path

        @layout_renderer ||= Tilt.new(path, ugly: true, filename: path)
      end

      def fix_path(html, prefix='./')
        elements = Nokogiri::HTML(html)

        fix_href_path(fix_src_path(elements, prefix), prefix).to_s
      end

      def fix_src_path(elements, prefix = './')
        elements.search("[src!=''][src!='']").each do |el|
          src = el.attr('src')
          next if src =~ /^(?:http:|https:|\/\/)/

          el.set_attribute 'src', normarize_path(prefix, src)
        end

        elements
      end

      def fix_href_path(elements, prefix = './')
        elements.search("[href][href!='#']").each do |el|
          href = el.attr('href')
          next if href =~ /^(?:http:|https:|\/\/)/

          if href == '/'
            el.set_attribute 'href', [prefix, 'index.html'].join
          else
            el.set_attribute 'href', normarize_path(prefix, href)
          end
        end

        elements
      end

      def normarize_path(prefix, path)
        absolute = /^\//

        if path =~ absolute
          [prefix, path.gsub(absolute, '')].join
        else
          path
        end
      end
    end
  end
end
