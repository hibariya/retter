# coding: utf-8

require 'nokogiri'

module Retter
  class Entry
    class Article
      attr_accessor :entry, :id, :title, :body

      def initialize(attrs = {})
        @id, @entry, @title, @body = attrs.values_at(:id, :entry, :title, :body)
      end

      def to_s
        body
      end

      def next
        articles[index.next] || (entry.next && entry.next.articles.first)
      end

      def prev
        index.pred < 0 ? (entry.prev && entry.prev.articles.last) : articles[index.pred]
      end

      def index
        articles.index(self)
      end

      def articles
        @articles ||= entry.articles
      end

      def snippet(length = 200)
        snip = tags_stripped_body[0, length]

        tags_stripped_body.length > length ? "#{snip}..." : snip
      end

      def tags_stripped_body
        @tags_stripped_body ||= body.gsub(/<\/?\s?[^>]+>/, '')
      end
    end

    include Stationery

    attr_accessor :date, :lede, :body, :articles
    attr_reader :pathname

    def initialize(attrs={})
      @date, @body = attrs.values_at(:date, :body)

      pathname_by_date = Entries.retters_dir.join(date.strftime('%Y%m%d.md'))
      @pathname = attrs[:pathname] || pathname_by_date

      attach_titles
      extract_articles
      load_lede
    end

    def path
      pathname.to_path
    end

    def to_s
      body
    end

    def next
      entries[index.next]
    end

    def prev
      entries[index.pred] unless index.pred < 0
    end

    def index
      entries.index(self) || 0
    end

    def has_articles?
      !articles.empty?
    end

    private

    def body_elements
      Nokogiri::HTML(body)
    end

    def attach_titles
      html = body_elements
      html.search('//h1').each_with_index do |h1, seq|
        h1.set_attribute 'id', "a#{seq}"
      end

      @body = html.search('//body/*').to_s
    end

    def extract_articles
      @articles = body_elements.search('body > *').each_with_object([]) {|c, r|
        if c.name == 'h1'
          r << Article.new(entry: self, id: c.attr('id'), title: c.text, body: '')
        else
          next if r.empty?

          article = r.last
          article.body += c.to_s
        end
      } || []
    end

    def load_lede
      @lede = body_elements.search('body > *').each_with_object('') {|c, r|
        break r if c.name == 'h1'
        r << c.to_s
      }
    end
  end
end
