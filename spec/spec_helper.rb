# coding: utf-8

require 'tapp'
require 'pry'
require 'retter'

RETTER_GEM_DIR = Pathname.new(File.dirname(__FILE__) + '/../').realpath

Dir[File.dirname(__FILE__) + '/support/*'].each {|f| require f }

RSpec.configure do |config|
  config.run_all_when_everything_filtered = true
  config.treat_symbols_as_metadata_keys_with_true_values = true
  config.order = 'random'

  config.include Retter::ExampleHelper

  config.before :suite do
    Retter::TestSite.tap do |test_site|
      test_site.generate_skel 'default'
      test_site.generate_skel 'multi_branch' do |site_dir|
        Retter::Repository.new site_dir do |repo|
          repo.checkout '--orphan', 'source' do
            repo.commit '-m', 'Initial'
          end

          repo.rm '-r', 'source', 'Retterfile'
          repo.commit '-m', 'Remove source files'
        end
      end
    end
  end

  config.before :all do
    Retter::TestSite.sites_dir.tap do |dir|
      dir.rmtree if dir.directory?
    end
  end

  config.before :each do |example|
    Retter::ExampleHelper.remove_retter_env

    ENV['EDITOR'] = RETTER_GEM_DIR.join('spec/bin/fake_editor').to_path
  end

  config.around :each, :with_default_site do |example|
    Retter::TestSite.create 'default' do |site_dir|
      example.run
    end
  end

  config.around :each, :with_multi_branch_site do |example|
    Retter::TestSite.create 'multi_branch' do |site_dir|
      example.run
    end
  end
end
