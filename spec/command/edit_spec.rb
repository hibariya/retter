# coding: utf-8

require 'spec_helper'

describe 'Retter::Command#edit', clean: :all do
  context 'no options' do
    before do
      command.should_receive(:invoke_after).with(:edit)

      invoke_command :edit
    end

    it { wip_file.should written }
  end

  context 'after edit and rebind (no options)' do
    let(:date_str)    { '2011/01/01' }
    let(:today_entry) { find_entry_by_string(date_str) }

    before do
      time_travel_to date_str

      today_entry.pathname.open('w') { |f| f.puts 'written' }

      invoke_command :rebind
      invoke_command :edit
    end

    specify 'wip file should not be written' do
      wip_file.should_not be_exist
    end
  end

  context 'with date (YYYYMMDD) option' do
    before do
      invoke_command :edit, '20110101'
    end

    it { wip_file.should_not written }

    describe 'date file' do
      subject { markdown_file('20110101' ) }

      it { should written }
    end
  end

  context 'with date (1.day.ago) option' do
    before do
      time_travel_to '2011/04/02'

      invoke_command :edit, '1.day.ago'
    end

    describe 'target date file' do
      subject { markdown_file('2011/04/01') }

      it { should written }
    end
  end

  context 'with date (yesterday) option' do
    before do
      time_travel_to '2011/04/02'

      invoke_command :edit, 'yesterday'
    end

    describe 'target date file' do
      subject { markdown_file('2011/04/01') }

      it { should written }
    end
  end

  context 'with filename (20110401.md) option' do
    before do
      FileUtils.touch markdown_file('20110401')

      Retter::Site.reset! # XXX

      invoke_command :edit, '20110401.md'
    end

    describe 'target date file' do
      subject { markdown_file('20110401') }

      it { should written }
    end
  end

  context 'with no exist filename option' do
    it {
      -> { invoke_command :edit, '19850126.md' }.should raise_error(Retter::EntryLoadError)
    }
  end

  context 'with filename (today.md) option' do
    before do
      FileUtils.touch wip_file.to_path

      invoke_command :edit, 'today.md'
    end

    describe 'target file' do
      it { wip_file.should written }
    end
  end

  context 'with silent option' do
    before do
      command.should_not_receive(:invoke_after)

      invoke_command :edit, silent: true
    end

    it { wip_file.should written }
  end
end
