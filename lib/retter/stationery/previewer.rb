# coding: utf-8

module Retter::Stationery
  class Previewer
    attr_reader :config

    def initialize(date, config)
      @config, @date = config, date
      @body, @entry  = *nil

      load_retter_file
      load_wip_entry_if_needed
    end

    def file_path
      config.retter_home.join '.preview.html'
    end

    def renderer
      Haml::Engine.new(config.layout_file.read, ugly: true)
    end

    def entry_renderer
      Haml::Engine.new(config.entry_layout_file.read, ugly: true)
    end

    def print
      build_entry
      print_html 
    end

    private

    def print_html
      scope = View::Scope.new(config)
      part = entry_renderer.render(scope, entry: @entry)
      html = renderer.render(scope, content: part, entries: [@entry])

      file_path.open('w') do |file|
        file.puts View::Helper.fix_path(html, './')
      end
    end

    def build_entry
      @entry = Retter::Entry.new(date: @date, body: Retter::Stationery.parser.render(@body))
    end

    def load_retter_file
      retter_file = config.retter_file(@date)
      @body = retter_file.exist? ? retter_file.read : ''
    end

    def load_wip_entry_if_needed
      if @date == Date.today && config.wip_file.exist?
        @body = [@body, config.wip_file.read].join("\n")
      end
    end
  end
end
