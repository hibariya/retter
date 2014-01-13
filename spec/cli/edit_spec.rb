require 'spec_helper'

describe 'retter edit', :with_test_site do
  context 'with no keywords' do
    before do
      invoke_retter 'edit'
    end

    subject { Pathname('source/retters/today.md') }

    it { should written }
  end

  context 'with date keyword' do
    before do
      invoke_retter 'edit', '20140101'
    end

    subject { Pathname('source/retters/20140101.md') }

    it { should written }
  end

  context 'with human readable date keyword' do
    before do
      invoke_retter 'edit', '2014-01-02'
    end

    subject { Pathname('source/retters/20140102.md') }

    it { should written }
  end

  context 'with date filename' do
    before do
      invoke_retter 'edit', '20140103.md'
    end

    subject { Pathname('source/retters/20140103.md') }

    it { should written }
  end

  context 'with alias keyword' do
    let(:path) { Pathname('source/retters/20140104.md') }

    before do
      FileUtils.touch path

      invoke_retter 'edit', 'e0'
    end

    subject { path }

    it { should written }
  end
end
