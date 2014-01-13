require 'chronic'
require 'date'
require 'nokogiri'

module Retter
  module StaticSite
    module MarkdownEntry
      class << self
        attr_accessor :source_path, :renderer
        attr_writer :wip_file

        def wip_file
          @wip_file || source_path.try(:join, 'today.md')
        end
      end

      Retter.on_initialize do |config|
        self.renderer    = config.renderer
        self.wip_file    = config.wip_file
        self.source_path = config.source_path.try(:join, 'retters')

        -> { Retter::Entry.load }
      end

      extend ActiveSupport::Concern

      module ClassMethods
        def load
          return false unless MarkdownEntry.source_path

          load_entries
          load_wip_entry

          all.sort_by! &:date
        end

        def generate_entry_path(keyword)
          if entry = find_by_keyword(keyword)
            entry.source_path
          elsif date = Entry::Utils.parse_date(keyword)
            MarkdownEntry.source_path.join(date.strftime('%Y%m%d.md'))
          else
            if entry = find(Date.today)
              entry.source_path
            else
              MarkdownEntry.wip_file
            end
          end
        end

        private

        def load_entries
          wip_file_path = MarkdownEntry.wip_file.to_path

          self.all =
            Dir.glob(MarkdownEntry.source_path.join('*.md')).reject {|path|
              path == wip_file_path
            }.map {|path|
              new.tap {|e| e.load path }
            }
        end

        def load_wip_entry
          if MarkdownEntry.wip_file.exist?
            wip_entry = new.tap {|e| e.load(MarkdownEntry.wip_file) }

            all << wip_entry unless find(wip_entry.date)
          end
        end
      end

      def load(path)
        @source_path = Pathname(path)

        fname = source_path.basename('.*').to_s
        @date = Entry::Utils.parse_date(fname)

        load_content
      end

      def commit!(date = Date.today)
        raise 'Already committed' unless wip?

        new_source = source_path.dirname.join(date.strftime('%Y%m%d.md'))

        source_path.rename new_source
        @source_path = new_source
      end

      def wip?
        source_path == MarkdownEntry.wip_file
      end

      private

      def load_content
        md   = source_path.read
        html = Nokogiri::HTML(markdown.render(md))

        @lede        = ''
        @articles    = html.search('body > *').to_a.each.with_index.with_object([]) {|(el, i), articles|
          if el.name == 'h1'
            articles << Entry::Article.new(entry: self, id: "a#{articles.size}", title: el.text, body: '')
          else
            if articles.empty?
              @lede << el.to_s
            else
              articles.last.body << el.to_s
            end
          end
        }
      end

      def markdown
        @markdown ||= Markdown.new(MarkdownEntry.renderer || Markdown::Renderer)
      end
    end
  end
end
