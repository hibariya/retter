# coding: utf-8

module Retter
  module Page
    class Entry
      class ViewContext < Base::ViewContext
        attr_reader :entry

        def initialize(entry)
          @entry = entry
        end
      end

      include Base

      attr_reader :entry

      def initialize(entry)
        super()

        @path_prefix = '../'
        @entry       = entry
        @title       = "#{entry.date} - #{config.title}"
      end

      def path
        Page.entry_file(entry.date)
      end

      def template_path
        Page.find_template_path('entry')
      end

      def bind
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
end
