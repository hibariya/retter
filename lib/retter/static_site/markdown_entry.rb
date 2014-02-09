require 'chronic'
require 'date'
require 'nokogiri'

module Retter
  module StaticSite
    module MarkdownEntry
      mattr_accessor :source_path, :wip_file, :markdown

      extend ActiveSupport::Concern

      def load(path)
        @source_path = Pathname(path)

        fname = source_path.basename('.*').to_s
        @date = Entry::Utils.parse_date(fname)

        load_markdown
      end

      def commit!(date = Date.today)
        raise 'Already committed' unless wip?

        new_path = source_path.dirname.join(date.strftime('%Y%m%d.md'))
        source_path.rename new_path
        @source_path =     new_path
      end

      def wip?
        source_path == MarkdownEntry.wip_file
      end

      private

      def load_markdown
        html     = Nokogiri::HTML(MarkdownEntry.markdown.render(source_path.read))
        elements = html.search('body > *').to_a

        @lede     = ''
        @articles = elements.each.with_object([]) {|el, articles|
          if el.name == 'h1'
            articles << Entry::Article.new(entry: self, id: "a#{articles.size}", title: el.text, body: '')
          else
            if articles.empty?
              @lede << el.to_s
              next
            end

            articles.last.body << el.to_s
          end
        }
      end

      module ClassMethods
        def load
          return unless MarkdownEntry.source_path

          load_entries
          load_wip_entry

          all.sort_by! &:date
        end

        def generate_entry_path(keyword)
          if found_entry = find_by_keyword(keyword)
            found_entry.source_path
          elsif date = Entry::Utils.parse_date(keyword)
            MarkdownEntry.source_path.join(date.strftime('%Y%m%d.md'))
          else
            if today_entry = find(Date.today)
              today_entry.source_path
            else
              MarkdownEntry.wip_file
            end
          end
        end

        private

        def load_entries
          wip_file_path = MarkdownEntry.wip_file.to_path
          except_wip    = Dir.glob("#{MarkdownEntry.source_path}/*.md").reject {|path| path == wip_file_path }

          self.all = except_wip.map {|path|
            new.tap {|e| e.load path }
          }
        end

        def load_wip_entry
          return unless MarkdownEntry.wip_file.exist?

          wip_entry = new.tap {|e| e.load(MarkdownEntry.wip_file) }

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

        -> { Retter::Entry.load }
      end
    end
  end
end
