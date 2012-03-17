# coding: utf-8

require 'builder'
require 'uri'

class Retter::Pages::Feed
  include Retter::Page

  def pathname
    config.feed_file
  end

  def print
    pathname.open('w') {|f| f.puts rss }
  end

  private

  def entry_url(date, id = nil)
    (URI.parse(config.url) + date.strftime('/entries/%Y%m%d.html')).to_s
  end

  def rss
    xml = Builder::XmlMarkup.new
    xml.instruct!
    xml.rdf:RDF, :xmlns        => 'http://purl.org/rss/1.0/',
                 :'xmlns:rdf'  => 'http://www.w3.org/1999/02/22-rdf-syntax-ns#',
                 :'xmlns:dc'   => 'http://purl.org/dc/elements/1.1/',
                 :'xml:lang'   => 'ja' do
      xml.channel :'rdf:about' => config.url do
        xml.title config.title
        xml.link config.url
        xml.dc:date, entries.empty? ? nil : entries.first.date
        xml.description config.description
        xml.items { xml.rdf(:Seq) { entries.each {|e| xml.rdf:li, :'rdf:resource' => entry_url(e.date) } } }
      end

      entries[0...20].each do |entry| # XXX hardcoding
        xml.item about: entry_url(entry.date) do
          xml.title entry.date.strftime('%Y/%m/%d')
          xml.description { xml.cdata! entry.body }
          xml.dc:date, entry.date
          xml.link     entry_url(entry.date)
          xml.author   config.author
        end
      end
    end
  end
end
