# coding: utf-8

require 'builder'
require 'uri'

module Retter
  module Page
    class Feed
      include Base

      def path
        config.retter_home.join('entries.rss')
      end

      def bind
        print rss
      end

      private

      def print(content)
        path.open('w') {|f| f.write content }
      end

      def articles(limit = 20)
        entries.map {|e| e.articles.reverse }.flatten[0..limit]
      end

      def helper
        @helper ||= Object.new.extend(Page::ViewHelper)
      end

      def rss
        xml = Builder::XmlMarkup.new
        xml.instruct!
        xml.rdf:RDF, :xmlns           => 'http://purl.org/rss/1.0/',
                     :'xmlns:rdf'     => 'http://www.w3.org/1999/02/22-rdf-syntax-ns#',
                     :'xmlns:dc'      => 'http://purl.org/dc/elements/1.1/',
                     :'xmlns:content' => 'http://purl.org/rss/1.0/modules/content/',
                     :'xml:lang'      => 'ja' do
          xml.channel :'rdf:about' => config.url do
            xml.title config.title
            xml.link config.url
            xml.dc:date, (entries.empty? ? Time.now : entries.first.date).iso8601
            xml.description config.description
            xml.items { xml.rdf(:Seq) { articles.each {|a| xml.rdf:li, :'rdf:resource' => helper.article_url(a) } } }
          end

          articles.each do |article|
            xml.item about: helper.article_url(article) do
              xml.title             article.title
              xml.description       article.snippet
              xml.content(:encoded) { xml.cdata! article.body }
              xml.dc:date,          article.entry.date.iso8601
              xml.link              helper.article_url(article)
              xml.author            config.author
            end
          end
        end
      end
    end
  end
end
