# coding: utf-8

RETTER_ROOT = Pathname.new(File.dirname(__FILE__) + '/../').realpath

require  RETTER_ROOT.join('lib', 'retter')
require 'tapp'

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

RSpec.configure do |config|
  config.filter_run focus: true
  config.run_all_when_everything_filtered = true

  retter_home = RETTER_ROOT.join('tmp', 'test')
  skel        = RETTER_ROOT.join('lib', 'generator', 'skel')

  config.before(:each, clean: :all) do
    FileUtils.cp_r skel, retter_home.dirname.join('test')
  end

  config.after(:each, clean: :all) do
    FileUtils.rm_rf retter_home
  end

  config.include Retter::ConfigSupport
end
