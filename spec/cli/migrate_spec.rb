require 'spec_helper'

describe 'retter migrate' do
  before :all do
    Dir.chdir TEST_TMP_DIR do
      FileUtils.cp_r GEM_DIR.join('spec/fixtures/sites/site-0.2.5'), 'old-site'

      Dir.chdir 'old-site' do
        result = invoke_retter('migrate')
        result.status.should be_success
      end
    end
  end

  around :each do |example|
    Dir.chdir TEST_TMP_DIR.join('old-site') do
      example.run
    end
  end

  specify 'source files are migrated' do
    Pathname('layouts').should_not      be_exist
    Pathname('retters').should_not      be_exist

    Pathname('source/retters').should   be_exist
    Pathname('source/assets').should    be_exist
    Pathname('source/templates').should be_exist
  end

  specify 'symlinks for old html are created' do
    Pathname('profile.html').should be_symlink
  end

  specify 'edit, list and build commands should be success' do
    Retter::StaticSite::Repository.new '.' do |repo|
      repo.init
      repo.add '-A'
      repo.add '-u'
      repo.commit '-m', 'Migrated'
    end

    invoke_retter('edit').status.should  be_success
    invoke_retter('list').status.should  be_success
    invoke_retter('build').status.should be_success

    %w(index.html entries.html entries.rss).each do |file|
      Pathname(file).should written
    end
  end
end
