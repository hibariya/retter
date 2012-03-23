# coding: utf-8

require 'tilt'
require 'haml'
require 'nokogiri'

module Retter
  module Page
    require 'retter/page/view_helper'

    include Stationery

    attr_reader :path_prefix, :title

    def initialize
      @path_prefix = './'
      @title       = config.title
    end

    def print
      part = Tilt.new(
        part_layout_pathname.to_path,
        ugly: true,
        filename: part_layout_pathname.to_path
      ).render(view_scope)

      print_with_layout part
    end

    def pathname
      raise NotImplementedError
    end

    def path
      pathname.to_path
    end

    def part_layout_pathname
      raise NotImplementedError
    end

    private

    def print_with_layout(content)
      draft = layout_renderer.render(view_scope, content: content, title: title)
      path_fixed = fix_path(draft, path_prefix)

      pathname.open('w') {|f| f.puts path_fixed }
    end

    def layout_renderer
      layout_file = Pages.layout_file.to_path
      @layout_renderer ||= Tilt.new(layout_file, ugly: true, filename: layout_file)
    end

    def fix_path(html, prefix='./')
      elements = Nokogiri::HTML(html)

      fix_href_path(fix_src_path(elements, prefix), prefix).to_s
    end

    def fix_src_path(elements, prefix = './')
      elements.search("[src!=''][src!='']").each do |el|
        src = el.attr('src').scan(/[^\.\/]{3}.*/).first
        next if src =~ /^(?:http|https):\/\//

        el.set_attribute 'src', [prefix, src].join
      end

      elements
    end

    def fix_href_path(elements, prefix = './')
      elements.search("[href][href!='#']").each do |el|
        href = el.attr('href')
        next if href =~ /^(?:http|https):\/\//

        if href == '/'
          el.set_attribute 'href', [prefix, 'index.html'].join
        else
          el.set_attribute 'href', [prefix, href.scan(/[^\.\/]{3}.*/).first].join
        end
      end

      elements
    end

    view_scope = Object.new
    view_scope.extend ViewHelper

    define_method :view_scope do
      view_scope
    end
  end
end
