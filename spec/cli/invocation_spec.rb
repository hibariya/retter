require 'spec_helper'

describe 'invocation' do
  context 'RETTER_ROOT is not set' do
    specify do
      Dir.chdir Retter::TestSite.tmpdir do
        invoke_retter('version', retter_root: nil).should be_exit_successfully
      end
    end
  end

  context 'RETTER_ROOT is empty' do
    specify do
      Dir.chdir Retter::TestSite.tmpdir do
        invoke_retter('version', retter_root: '').should be_exit_successfully
      end
    end
  end
end
