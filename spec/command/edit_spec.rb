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

  context 'no options after rebind' do
    let(:date_str) { '20110101' }

    before do
      Date.stub!(:today).and_return(Date.parse(date_str))

      command.edit
      command.bind
      command.edit
    end

    it { wip_file.should_not be_exist }

    describe "today's file" do
      subject { retter_config.retters_dir.join("#{date_str}.md") }

      it { should written }
    end
  end

  context 'with date (YYYYMMDD) option' do
    let(:date_str) { '20110101' }

    before do
      command.should_receive(:invoke_after).with(:edit)
      command.edit date_str
    end

    it { wip_file.should_not be_exist }

    describe 'target date file' do
      subject { retter_config.retter_file(Date.parse(date_str)) }

      it { should written }
    end
  end

  context 'with date (1.day.ago) option' do
    before do
      Time.stub!(:now).and_return(Time.parse('2011/04/02'))

      command.should_receive(:invoke_after).with(:edit)
      command.edit '1.day.ago'
    end

    describe 'target date file' do
      subject { retter_config.retter_file(Date.parse('2011/04/01')) }

      it { should written }
    end
  end

  context 'with date (yesterday) option' do
    before do
      Time.stub!(:now).and_return(Time.parse('2011/04/02'))

      command.should_receive(:invoke_after).with(:edit)
      command.edit 'yesterday'
    end

    describe 'target date file' do
      subject { retter_config.retter_file(Date.parse('2011/04/01')) }

      it { should written }
    end
  end

  context 'with filename (20110401.md) option' do
    before do
      FileUtils.touch retter_config.retter_file(Date.parse('20110401'))

      command.should_receive(:invoke_after).with(:edit)
      command.edit '20110401.md'
    end

    describe 'target date file' do
      subject { retter_config.retter_file(Date.parse('2011/04/01')) }

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

      command.should_receive(:invoke_after).with(:edit)
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
