# coding: utf-8

module Retter::ConfigSupport
  def retter_config
    return @config if @config

    env = {
      'EDITOR'      => 'touch',
      'RETTER_HOME' => RETTER_ROOT.join('tmp', 'test').to_s
    }

    @config = Retter::Config.new(env)
  end
end
