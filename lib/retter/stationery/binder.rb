# coding: utf-8

module Retter::Stationery
  class Binder
    attr_reader :config, :entries

    extend Forwardable

    def_delegators :@config, *Retter::Config.delegatables

    def initialize(config)
      @config = config
    end

    def rebind!
      commit_wip_file

      @entries = Retter::Stationery.scan(retters_dir)

      bind_entries
      print_index
      print_profile
      print_rss
    end

    def commit_wip_file
      if wip_file.exist?
        html = wip_file.read
        retter_file(Date.today).open('a') {|f| f.puts html }
        wip_file.unlink
      end
    end

    def bind_entries
      @entries.each {|entry| print_entry entry }
      print_toc
    end

    def print_entry(entry)
      title = "#{entry.titles.values.first} - #{config.title}"
      part = entry_renderer.render(view_scope, entry: entry)
      html = layout_renderer.render(view_scope, content: part, title: title)

      entry_file(entry.date).open('w') do |f|
        f.puts View::Helper.fix_path(html, '../')
      end
    end

    def print_index
      part = Haml::Engine.new(index_layout_file.read, ugly: true).render(view_scope)
      html = layout_renderer.render(view_scope, content: part, title: config.title)

      index_file.open('w') do |f|
        f.puts  View::Helper.fix_path(html, './')
      end
    end

    def print_profile
      part = Haml::Engine.new(profile_layout_file.read, ugly: true).render(view_scope)
      html = layout_renderer.render(view_scope, content: part, title: config.title)

      profile_file.open('w') do |f|
        f.puts  View::Helper.fix_path(html, './')
      end
    end

    def print_toc
      part = Haml::Engine.new(entries_layout_file.read, ugly: true).render(view_scope)
      html = layout_renderer.render(view_scope, content: part, title: config.title)

      entries_file.open('w') do |f|
        f.puts  View::Helper.fix_path(html, './')
      end
    end

    def print_rss
      feed_file.open('w') {|f| f.puts rss }
    end

    def rss
      xml = Builder::XmlMarkup.new
      xml.instruct!
      xml.rdf:RDF, :xmlns        => 'http://purl.org/rss/1.0/',
                   :'xmlns:rdf'  => 'http://www.w3.org/1999/02/22-rdf-syntax-ns#',
                   :'xmlns:dc'   => 'http://purl.org/dc/elements/1.1/',
                   :'xml:lang'   => 'ja' do
        xml.channel :'rdf:about' => url do
          xml.title title
          xml.link url
          xml.dc:date, entries.first.date
          xml.description description
          xml.items { xml.rdf(:Seq) { entries.each {|e| xml.rdf:li, :'rdf:resource' => entry_url(e.date) } } }
        end

        entries.each do |entry|
          xml.item about: entry_url(entry.date) do
            xml.title entry.date.strftime('%Y/%m/%d')
            xml.description { xml.cdata! entry.body }
            xml.dc:date, entry.date
            xml.link     entry_url(entry.date)
            xml.author   author
          end
        end
      end
    end

    def entry_url(date, id = nil)
      (URI.parse(url) + date.strftime('/entries/%Y%m%d.html')).to_s
    end

    private

    def view_scope
      @view_scope ||= View::Scope.new(config, entries: entries)
    end

    def layout_renderer
      @layout_renderer ||= Haml::Engine.new(layout_file.read, ugly: true)
    end

    def entry_renderer
      @entry_renderer ||= Haml::Engine.new(entry_layout_file.read, ugly: true)
    end
  end
end
