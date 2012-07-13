# coding: utf-8

module Retter
  class Preprint
    class ViewContext < Page::Base::ViewContext
      attr_reader :entry

      def initialize(entry)
        @entry = entry
      end
    end

    include Page::Base

    def path
      config.retter_home.join '.preview.html'
    end

    def template_path
      Page.find_template_path('entry')
    end

    def bind(entry)
      context = ViewContext.new(entry)
      part    = Tilt.new(
        template_path.to_path,
        ugly: true,
        filename: template_path.to_path
      ).render(context)

      print part
    end
  end
end
