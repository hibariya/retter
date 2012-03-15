# coding: utf-8

require 'spec_helper'

describe 'Retter::Command#edit', clean: :all do
  context 'no options' do
    before do
      command.should_receive(:invoke_after).with(:edit)
      command.edit
    end

    it { wip_file.should written }
  end

  context 'after edit and rebind (no options)' do
    let(:today) { '20110101' }
    let(:today_entry) { Retter.entries.detect_by_string(today) }

    before do
      stub_time today
      today_entry.pathname.open('w') { |f| f.puts 'written' }
      command.rebind

      command.edit
    end

    specify 'wip file should not be written' do
      wip_file.should_not be_exist
    end
  end

  context 'with date (YYYYMMDD) option' do
    let(:date_str) { '20110101' }
    let(:date) { Date.parse(date_str) }

    before do
      command.edit date_str
    end

    it { wip_file.should_not written }

    describe 'date file' do
      subject { retter_config.retter_file(date) }

      it { should written }
    end
  end

  context 'with date (1.day.ago) option' do
    before do
      stub_time '2011/04/02'

      command.edit '1.day.ago'
    end

    describe 'target date file' do
      let(:one_day_ago) { Date.parse('2011/04/01') }

      subject { retter_config.retter_file(one_day_ago) }

      it { should written }
    end
  end

  context 'with date (yesterday) option' do
    before do
      stub_time '2011/04/02'

      command.edit 'yesterday'
    end

    describe 'target date file' do
      let(:yesterday) { Date.parse('2011/04/01') }

      subject { retter_config.retter_file(yesterday) }

      it { should written }
    end
  end

  context 'with filename (20110401.md) option' do
    let(:a_day) { Date.parse('20110401') }

    before do
      FileUtils.touch retter_config.retter_file(a_day)

      command.edit '20110401.md'
    end

    describe 'target date file' do
      subject { retter_config.retter_file(a_day) }

      it { should written }
    end
  end

  context 'with no exist filename option' do
    it {
      -> { command.edit '19850126.md' }.should raise_error(Retter::EntryLoadError)
    }
  end

  context 'with filename (today.md) option' do
    before do
      FileUtils.touch retter_config.wip_file.to_s

      command.edit 'today.md'
    end

    describe 'target file' do
      subject { retter_config.wip_file }

      it { should written }
    end
  end

  context 'with silent option' do
    before do
      command.stub!(:options) { {silent: true} }

      command.should_not_receive(:invoke_after)
      command.edit
    end

    it { wip_file.should written }
  end
end
