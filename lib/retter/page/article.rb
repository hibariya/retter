# coding: utf-8

module Retter
  module Page
    class Article
      class ViewContext < Base::ViewContext
        attr_reader :entry, :article

        def initialize(entry, article)
          @entry, @article = entry, article
        end
      end

      include Base

      attr_reader :article

      def initialize(article)
        super()
        @path_prefix = '../../'
        @article     = article
        @title       = "#{article.title} - #{config.title}"
      end

      def path
        Page.entry_dir(article.entry.date).join("#{article.id}.html")
      end

      def template_path
        Page.find_template_path('article')
      end

      def bind
        context = ViewContext.new(article.entry, article)
        part    = Tilt.new(
          template_path.to_path,
          ugly: true,
          filename: template_path.to_path
        ).render(context)

        print part
      end

      private

      def print(part)
        entry_dir = Page.entry_dir(article.entry.date)
        entry_dir.mkdir unless entry_dir.directory?

        super
      end
    end
  end
end
