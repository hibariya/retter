# coding: utf-8

require 'tapp'
require 'retter'

GEM_DIR      = Pathname.new(File.dirname(__FILE__) + '/../').realpath
TEST_TMP_DIR = GEM_DIR.join('tmp/test')

Dir[File.dirname(__FILE__) + '/support/*'].each {|f| require f }

RSpec.configure do |config|
  config.run_all_when_everything_filtered = true
  config.treat_symbols_as_metadata_keys_with_true_values = true

  config.include Retter::ExampleHelper

  template_dir  = GEM_DIR.join('tmp/test_site')
  test_site_dir = TEST_TMP_DIR.join('site')

  config.before :suite do
    FileUtils.rm_r template_dir if template_dir.exist?
    FileUtils.mkdir_p TEST_TMP_DIR

    Dir.chdir GEM_DIR.join('tmp') do
      Retter::ExampleHelper.invoke_retter 'new', template_dir.basename
    end
  end

  config.before :all do
    clean_test_tmp_dir
  end

  config.before :each do |example|
    ENV['RETTER_HOME'] = ENV['RETTER_ROOT'] = nil
    ENV['EDITOR']      = GEM_DIR.join('spec/bin/fake_editor').to_path
  end

  config.around :each, :with_test_site do |example|
    clean_test_tmp_dir
    FileUtils.cp_r template_dir, test_site_dir

    Dir.chdir test_site_dir do
      example.run
    end
  end
end
