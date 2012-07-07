# coding: utf-8

require 'nokogiri'
require 'stringio'

module ExampleGroupHelper
  module RetterShortcuts
    def command
      @command ||= Retter::Command.new
    end

    def wip_file
      Retter.entries.wip_file
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
