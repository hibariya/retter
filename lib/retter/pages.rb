# coding: utf-8

module Retter
  module Page
    module ViewHelper
      include Retter::Stationery

      def entry_path(date, id = nil)
        date.strftime('/entries/%Y%m%d.html') + (id ? "##{id}" : '')
      end

      def article_path(date, id)
        date.strftime("/entries/%Y%m%d/#{id}.html")
      end
    end

    include Retter::Stationery

    attr_reader :path_prefix, :title

    def initialize
      @path_prefix = './'
      @title       = config.title
    end

    def print
      part = Haml::Engine.new(part_layout_pathname.read, ugly: true).render(view_scope)

      print_with_layout part
    end

    def pathname
      raise NotImplementedError
    end

    def path
      pathname.to_s
    end

    def part_layout_pathname
      raise NotImplementedError
    end

    private

    def print_with_layout(content)
      draft = layout_renderer.render(view_scope, content: content, title: title)
      path_fixed = fix_path(draft, path_prefix)

      pathname.open('w') {|f| f.puts path_fixed }
    end

    def layout_renderer
      @layout_renderer ||= Haml::Engine.new(config.layout_file.read, ugly: true)
    end

    def fix_path(html, prefix='./')
      elements = Nokogiri::HTML(html)

      fix_href_path(fix_src_path(elements, prefix), prefix).to_s
    end

    def fix_src_path(elements, prefix = './')
      elements.search("[src!=''][src!='']").each do |el|
        src = el.attr('src').scan(/[^\.\/]{3}.*/).first
        next if src =~ /^(?:http|https):\/\//

        el.set_attribute 'src', [prefix, src].join
      end

      elements
    end

    def fix_href_path(elements, prefix = './')
      elements.search("[href][href!='#']").each do |el|
        href = el.attr('href')
        next if href =~ /^(?:http|https):\/\//

        if href == '/'
          el.set_attribute 'href', [prefix, 'index.html'].join
        else
          el.set_attribute 'href', [prefix, href.scan(/[^\.\/]{3}.*/).first].join
        end
      end

      elements
    end

    view_scope = Object.new
    view_scope.extend ViewHelper

    define_method :view_scope do
      view_scope
    end
  end

  class Pages
    class Index
      include Retter::Page

      def pathname
        config.index_file
      end

      def part_layout_pathname
        config.index_layout_file
      end
    end

    class Profile
      include Retter::Page

      def pathname
        config.profile_file
      end

      def part_layout_pathname
        config.profile_layout_file
      end
    end

    class Archive
      include Retter::Page

      def pathname
        config.entries_file
      end

      def part_layout_pathname
        config.entries_layout_file
      end
    end

    class Feed
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

          entries.each do |entry|
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

    class Entry
      include Retter::Page

      attr_reader :entry

      def initialize(entry)
        super()
        @path_prefix = '../'
        @entry       = entry
        @title       = "#{entry.date.strftime('%Y/%m/%d')} - #{config.title}"
      end

      def pathname
        config.entry_file(entry.date)
      end

      def part_layout_pathname
        config.entry_layout_file
      end

      def print
        part = Haml::Engine.new(part_layout_pathname.read, ugly: true).render(view_scope, entry: entry)

        print_with_layout part
      end
    end

    class Article
      include Retter::Page

      attr_reader :article

      def initialize(article)
        super()
        @path_prefix = '../../'
        @article     = article
        @title       = "#{article.title} - #{config.title}"
      end

      def pathname
        config.entry_dir(article.entry.date).join("#{article.id}.html")
      end

      def part_layout_pathname
        config.article_layout_file
      end

      def print
        options = {entry: article.entry, article: article}
        part = Haml::Engine.new(part_layout_pathname.read, ugly: true).render(view_scope, options)

        mkdir
        print_with_layout part
      end

      def mkdir
        entry_dir = config.entry_dir(article.entry.date)
        entry_dir.mkdir unless entry_dir.directory?
      end
    end

    include Retter::Stationery

    attr_reader :index, :profile, :archive, :feed, :singleton_pages

    def initialize
      @singleton_pages = [Index, Profile, Archive, Feed].map(&:new)
      @index, @profile, @archive, @feed = *singleton_pages
    end

    def bind!
      print_entries

      singleton_pages.each(&:print)
    end


    def print_entries
      entries.each do |entry|
        entry_page = Entry.new(entry)
        entry_page.print

        entry.articles.each do |article|
          article_page = Article.new(article)
          article_page.print
        end
      end
    end
  end
end
