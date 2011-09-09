# coding: utf-8

module Retter::Stationery
  class Binder
    attr_reader :config, :entries

    def initialize(config)
      @config = config
    end

    def view_scope
      @view_scope ||= View::Scope.new(config, entries: entries)
    end

    def renderer
      Haml::Engine.new(config.layout_file.read, ugly: true)
    end

    def entries_renderer
      Haml::Engine.new(config.entries_layout_file.read, ugly: true)
    end

    def entry_renderer
      Haml::Engine.new(config.entry_layout_file.read, ugly: true)
    end

    def index_renderer
      Haml::Engine.new(config.index_layout_file.read, ugly: true)
    end

    def profile_renderer
      Haml::Engine.new(config.profile_layout_file.read, ugly: true)
    end

    def rebind!
      commit_wip_file

      @entries = Retter::Stationery.scan(config.retters_dir)

      bind_entries
      print_index
      print_profile
      print_rss
    end

    def commit_wip_file
      if config.wip_file.exist?
        html = config.wip_file.read
        config.retter_file(Date.today).open('a') {|f| f.puts html }
        config.wip_file.unlink
      end
    end

    def bind_entries
      @entries.each {|entry| print_entry entry }
      print_toc
    end

    def print_entry(entry)
      part = entry_renderer.render(view_scope, entry: entry)
      html = renderer.render(view_scope, content: part)

      config.entry_file(entry.date).open('w') do |f|
        f.puts View::Helper.fix_path(html, '../')
      end
    end

    def print_index
      part = index_renderer.render(view_scope)
      html = renderer.render(view_scope, content: part)

      config.index_file.open('w') do |f|
        f.puts  View::Helper.fix_path(html, './')
      end
    end

    def print_profile
      part = profile_renderer.render(view_scope)
      html = renderer.render(view_scope, content: part)

      config.profile_file.open('w') do |f|
        f.puts  View::Helper.fix_path(html, './')
      end
    end

    def print_toc
      part = entries_renderer.render(view_scope)
      html = renderer.render(view_scope, content: part)

      config.entries_file.open('w') do |f|
        f.puts  View::Helper.fix_path(html, './')
      end
    end

    def print_rss
      config.feed_file.open('w') {|f| f.puts rss }
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
          xml.dc:date, entries.first.date
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

    def entry_url(date, id = nil)
      (URI.parse(config.url) + date.strftime('/entries/%Y%m%d.html')).to_s
    end
  end
end
