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

  include Config
  include Shortcuts
end
