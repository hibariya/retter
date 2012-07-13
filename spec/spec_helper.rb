# coding: utf-8

require 'tapp'
require 'delorean'

if ENV['COVERAGE']
  require 'simplecov'
  SimpleCov.start
end

RETTER_ROOT = Pathname.new(File.dirname(__FILE__) + '/../').realpath
require RETTER_ROOT.join('lib', 'retter')

Dir[File.dirname(__FILE__) + '/support/*'].each {|f| require f }

RSpec.configure do |config|
  config.filter_run focus: true
  config.run_all_when_everything_filtered = true

  retter_home = RETTER_ROOT.join('tmp/test')
  skel        = RETTER_ROOT.join('lib/retter/generator/skel')
  fake_editor = RETTER_ROOT.join('spec/bin/fake_editor')

  config.before :each, clean: :all do
    FileUtils.cp_r skel, retter_home.dirname.join('test')
  end

  config.after :each, clean: :all do
    FileUtils.rm_rf retter_home

    Retter::Site.reset!
  end

  config.before :each do
    env = {'EDITOR' => fake_editor.to_path, 'RETTER_HOME' => RETTER_ROOT.join('tmp', 'test').to_s}

    Retter::Site.load env
  end

  config.include Delorean
  config.after :each do
    back_to_the_present
  end

  config.include ExampleGroupHelper
end
