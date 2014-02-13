require 'spec_helper'

describe 'retter new' do
  before :all do
    site_dir = Retter::TestSite.sites_dir

    FileUtils.mkdir_p site_dir

    Dir.chdir site_dir do |dir|
      result = invoke_retter('new', site_dir.join('new-site'), retter_root: '')

      raise result.inspect unless result.status.success?
    end
  end

  around :each do |example|
    Dir.chdir Retter::TestSite.sites_dir.join('new-site') do
      example.run
    end
  end

  specify 'files are installed' do
    Pathname('Retterfile').should be_exist
    Pathname('source').should     be_exist
  end

  specify 'current branch is master' do
    capture_command('git', 'branch').should match(/\*\smaster/)
  end
end
