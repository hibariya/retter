require 'chronic'
require 'date'
require 'nokogiri'

module Retter
  module StaticSite
    module MarkdownEntry
      FNAME_FORMAT = '%Y%m%d.md'

      class << self
        attr_accessor :source_path, :wip_file, :markdown
      end

      extend ActiveSupport::Concern

      included do
        alias_method_chain :source_path, :fallback
      end

      def load_entry(path)
        self.source_path = Pathname(path)

        fname = source_path.basename('.*').to_s
        self.date = Entry::Utils.parse_date(fname)

        load_markdown
      end

      def commit!(date = Date.today)
        raise 'Already committed' unless wip?

        new_path = source_path.dirname.join(date.strftime(FNAME_FORMAT))
        source_path.rename new_path
        self.source_path = new_path
      end

      def wip?
        source_path == MarkdownEntry.wip_file
      end

      private

      def source_path_with_fallback
        if origin = source_path_without_fallback
          origin
        elsif date?
          MarkdownEntry.source_path.join(date.strftime(FNAME_FORMAT))
        else
          MarkdownEntry.wip_file
        end
      end

      def load_markdown
        html     = Nokogiri::HTML(MarkdownEntry.markdown.render(source_path.read))
        elements = html.search('body > *').to_a

        self.lede     = ''
        self.articles = elements.each.with_object([]) {|el, articles|
          if el.name == 'h1'
            articles << Entry::Article.new(entry: self, position: articles.size, title: el.text, body: '')
          else
            if articles.empty?
              self.lede << el.to_s
              next
            end

            articles.last.body << el.to_s
          end
        }
      end

      module ClassMethods
        def load_entries
          return unless MarkdownEntry.source_path

          load_persisted_entries
          load_wip_entry

          all.sort_by! &:date
        end

        private

        def load_persisted_entries
          wip_file_path = MarkdownEntry.wip_file.to_path
          except_wip    = Dir.glob("#{MarkdownEntry.source_path}/*.md").reject {|path| path == wip_file_path }

          self.all = except_wip.map {|path|
            new.tap {|e| e.load_entry path }
          }
        end

        def load_wip_entry
          return unless MarkdownEntry.wip_file.exist?

          wip_entry = new.tap {|e| e.load_entry(MarkdownEntry.wip_file) }

          if find(wip_entry.date)
            # this file won't read while find(Date.today)
          else
            all << wip_entry
          end
        end
      end

      Retter.on_initialize do |config|
        self.source_path = config.source_path.try(:join, 'retters')
        self.wip_file    = source_path.try(:join, 'today.md')
        self.markdown    = Markdown.new(config.renderer || Markdown::Renderer)

        -> { Retter::Entry.load_entries }
      end
    end
  end
end
