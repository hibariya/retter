# coding: utf-8

require 'time'
require 'nokogiri'

module ExampleGroupHelper
  module RetterShortcuts
    def command
      @command ||= Retter::Command.new
    end

    def retter_config
      return @config if @config

      env = {'EDITOR' => 'echo written >', 'RETTER_HOME' => RETTER_ROOT.join('tmp', 'test').to_s}

      @config = Retter::Config.new(env)
    end

    def wip_file
      retter_config.wip_file
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
        stream = stream.to_s
        eval "$#{stream} = StringIO.new"
        yield
        result = eval("$#{stream}").string
      ensure
        eval("$#{stream} = #{stream.upcase}")
      end

      result
    end
  end

  module StubTime
    def stub_time(time_str)
      date = Date.parse(time_str)
      time = Time.parse(time_str)

      Date.stub!(:today).and_return(date)
      Time.stub!(:now).and_return(time)
    end
  end

  include RetterShortcuts
  include HTML
  include Stream
  include StubTime
end
