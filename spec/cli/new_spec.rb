require 'spec_helper'

describe 'retter new' do
  before :all do
    Dir.chdir TEST_TMP_DIR do
      result = invoke_retter('new', 'new-site')
      result.should be_exit_successfully
    end
  end

  around :each do |example|
    Dir.chdir TEST_TMP_DIR.join('new-site') do
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
