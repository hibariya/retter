require 'spec_helper'

describe 'retter migrate' do
  before :all do
    site_dir = Retter::TestSite.sites_dir

    FileUtils.mkdir_p site_dir

    Dir.chdir site_dir do
      FileUtils.cp_r RETTER_GEM_DIR.join('spec/fixtures/sites/site-0.2.5'), site_dir.join('old-site')

      Dir.chdir 'old-site' do
        result = invoke_retter('migrate')

        raise result.inspect unless result.status.success?
      end
    end
  end

  around :each do |example|
    Dir.chdir Retter::TestSite.sites_dir.join('old-site') do
      example.run
    end
  end

  describe 'migrated files' do
    specify 'source files are migrated' do
      Pathname('layouts').should_not      be_directory
      Pathname('retters').should_not      be_directory

      Pathname('source/retters').should   be_directory
      Pathname('source/assets').should    be_directory
      Pathname('source/templates').should be_directory
    end

    specify 'symlinks for old html are created' do
      Pathname('about.html').should be_symlink
    end
  end

  describe 're-generate html' do
    let(:html_files) { %w(index.html entries.html entries.rss) }

    before do
      Retter::Repository.new '.' do |repo|
        repo.init
        repo.add '-A'
        repo.add '-u'
        repo.commit '-m', 'Migrated'
      end

      FileUtils.rm html_files
    end

    specify 'edit, list and build commands should be success' do
      invoke_retter('edit').should  be_exit_successfully
      invoke_retter('list').should  be_exit_successfully
      invoke_retter('build').should be_exit_successfully

      html_files.each do |file|
        Pathname(file).should written
      end
    end
  end
end
