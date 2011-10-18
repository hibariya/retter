# coding: utf-8

require File.dirname(__FILE__) + '/../spec_helper'

describe 'Retter::Command#edit', clean: :all do
  let(:command) { Retter::Command.new }
  let(:wip_file) { retter_config.wip_file }

  before do
    Retter.stub!(:config) { retter_config }
  end

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

  context 'with date option' do
    let(:date_str) { '20110101' }

    before do
      command.stub!(:options) { {date: date_str} }

      command.should_receive(:invoke_after).with(:edit)
      command.edit
    end

    it { wip_file.should_not be_exist }

    describe 'target date file' do
      subject { retter_config.retter_file(Date.parse(date_str)) }

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
