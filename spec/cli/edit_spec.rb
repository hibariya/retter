require 'spec_helper'

describe 'retter edit' do
  context 'default site', :with_default_site do
    context 'with no keywords' do
      before do
        invoke_retter('edit').should be_exit_successfully
      end

      subject { Pathname('source/retters/today.md') }

      it { should written }
    end

    context 'with date keyword' do
      before do
        invoke_retter('edit', '20140101').should be_exit_successfully
      end

      subject { Pathname('source/retters/20140101.md') }

      it { should written }
    end

    context 'with human readable date keyword' do
      before do
        invoke_retter('edit', '2014-01-02').should be_exit_successfully
      end

      subject { Pathname('source/retters/20140102.md') }

      it { should written }
    end

    context 'with date filename' do
      before do
        invoke_retter('edit', '20140103.md').should be_exit_successfully
      end

      subject { Pathname('source/retters/20140103.md') }

      it { should written }
    end

    context 'with alias keyword' do
      let(:path) { Pathname('source/retters/20140104.md') }

      before do
        FileUtils.touch path

        invoke_retter('edit', 'e0').should be_exit_successfully
      end

      subject { path }

      it { should written }
    end
  end

  context 'multi branch', :with_multi_branch_site do
    let(:path) { Pathname('source/retters/today.md') }

    before do
      invoke_retter('edit').should be_exit_successfully
    end

    specify 'source branch has changes' do
      Retter::Repository.new '.' do |repo|
        repo.current_branch.should == 'master'
        repo.checkout 'source' do
          path.should written
        end
      end
    end
  end
end
