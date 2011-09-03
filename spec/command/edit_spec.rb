# coding: utf-8

require File.dirname(__FILE__) + '/../spec_helper'

describe 'Retter::Command#edit', clean: :all do
  let(:command) { Retter::Command.new }
  let(:wip_file) { retter_config.wip_file }

  before do
    command.stub!(:config) { retter_config }
  end

  context 'no options' do
    before do
      command.edit
    end

    it { wip_file.should be_exist }
  end

  context 'no options after rebind' do
    let(:date) { '20110101' }

    before do
      Date.stub!(:today).and_return(Date.parse(date))

      command.edit
      command.bind
      command.edit
    end

    it { wip_file.should_not be_exist }
    it { retter_config.retters_dir.join("#{date}.md").should be_exist }
  end

  context 'with date' do
    let(:date) { '20110101' }

    before do
      command.stub!(:options) { {date: date} }
      command.edit
    end

    it { wip_file.should_not be_exist }

    describe 'target date file' do
      subject { retter_config.retters_dir.join("#{date}.md") }

      it { should be_exist }
    end
  end
end
