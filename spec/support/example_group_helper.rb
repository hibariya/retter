module ExampleGroupHelper
  module Shortcuts
    def command
      @command ||= Retter::Command.new
    end

    def wip_file
      retter_config.wip_file
    end
  end

  module Config
    def retter_config
      return @config if @config

      env = {'EDITOR' => 'echo written >', 'RETTER_HOME' => RETTER_ROOT.join('tmp', 'test').to_s}

      @config = Retter::Config.new(env)
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

  include Config
  include Shortcuts
  include HTML
  include Stream
end
