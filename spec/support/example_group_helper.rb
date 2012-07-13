# coding: utf-8

require 'nokogiri'
require 'stringio'

module ExampleGroupHelper
  module RetterShortcuts
    def command
      @command ||= Retter::Command.new
    end

    def invoke_command(command_name, *args)
      @command ||= Retter::Command.new

      yield Retter::Site.config if block_given?

      if args.last.is_a?(Hash)
        options = args.pop

        @command.stub!(:options) { options }
      end

      @command.__send__ command_name, *args
    end

    def wip_file
      Retter::Site.entries.wip_file
    end

    def write_to_wip_file(body)
      wip_file.open('w') {|f| f.write body }
    end

    def generated_file(path)
      Retter::Site.config.retter_home.join(path)
    end

    def markdown_file(date)
      date = date_wrap(date)

      Retter::Site.entries.retter_file(date)
    end

    def find_entry_by_string(str)
      Retter::Site.entries.detect_by_string(str)
    end

    def entry_html_file(date)
      date = date_wrap(date)

      Retter::Page.entry_file(date)
    end

    def article_html_file(date, id)
      date = date_wrap(date)

      Retter::Page.entry_dir(date).join("#{id}.html")
    end

    private

    def date_wrap(str)
      Date.parse(str.to_s)
    end
  end

  module HTML
    def nokogiri(html)
      Nokogiri::HTML(html)
    end

    def texts_of(html, selector)
      nokogiri(html).search(selector).map {|el|
        el.text.strip
      }
    end
  end

  module Stream
    def capture(stream)
      begin
        eval "$#{stream} = StringIO.new"

        yield

        result = eval("$#{stream}").string
      ensure
        eval %($#{stream} = #{stream.upcase})
      end

      result
    end
  end

  include RetterShortcuts
  include HTML
  include Stream
end
