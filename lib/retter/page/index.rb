# coding: utf-8

module Retter
  module Page
    class Index
      include Base

      def path
        config.retter_home.join('index.html')
      end

      def template_path
        Page.find_template_path('index')
      end
    end
  end
end
