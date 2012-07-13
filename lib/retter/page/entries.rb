# coding: utf-8

module Retter
  module Page
    class Entries
      include Base

      def path
        config.retter_home.join('entries.html')
      end

      def template_path
        Page.find_template_path('entries')
      end
    end
  end
end
