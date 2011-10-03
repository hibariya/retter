# coding: utf-8

module Retter::Stationery
  class Previewer
    attr_reader :config

    extend Forwardable

    def_delegators :@config, *Retter::Config.delegatables

    def initialize(config, date)
      @config, @date = config, date
      @body, @entry  = *nil

      load_retter_file
      load_wip_entry_if_needed
    end

    def print
      build_entry
      print_html 
    end

    def file_path
      config.retter_home.join '.preview.html'
    end

    private

    def load_retter_file
      retter_file = retter_file(@date)
      @body = retter_file.exist? ? retter_file.read : ''
    end

    def load_wip_entry_if_needed
      if @date == Date.today && wip_file.exist?
        @body = [@body, wip_file.read].join("\n")
      end
    end

    def build_entry
      body_html = Retter::Stationery.markupper.render(@body)
      @entry    = Retter::Entry.new(date: @date, body: body_html)
    end

    def print_html
      scope = View::Scope.new(config)
      part = entry_renderer.render(scope, entry: @entry)
      html = renderer.render(scope, content: part, title: config.title, entries: [@entry])

      file_path.open('w') do |file|
        file.puts View::Helper.fix_path(html, './')
      end
    end

    def renderer
      Haml::Engine.new(layout_file.read, ugly: true)
    end

    def entry_renderer
      Haml::Engine.new(entry_layout_file.read, ugly: true)
    end
  end
end
