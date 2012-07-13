# coding: utf-8

require 'tilt'
require 'haml'
require 'nokogiri'

module Retter
  module Page
    autoload :Base,       'retter/page/base'
    autoload :ViewHelper, 'retter/page/view_helper'

    autoload :Index,   'retter/page/index'
    autoload :Profile, 'retter/page/profile'
    autoload :Entries, 'retter/page/entries'
    autoload :Feed,    'retter/page/feed'
    autoload :Entry,   'retter/page/entry'
    autoload :Article, 'retter/page/article'

    extend Configurable

    configurable :layouts_dir, :entries_dir

    class << self
      def find_template_path(name)
        detected = Dir.glob(layouts_dir.join("#{name}.*.*")).first

        Pathname.new(detected)
      end

      def layout_path
        @layout_path ||= find_template_path('retter')
      end

      def entry_file(date)
        entries_dir.join date.strftime('%Y%m%d.html')
      end

      def entry_dir(date)
        entries_dir.join date.strftime('%Y%m%d')
      end
    end
  end
end
