# coding: utf-8

require File.dirname(__FILE__) + '/../spec_helper'

describe 'Retter::Command#commit', clean: :all do
  let(:command) { Retter::Command.new }
  let(:wip_file) { retter_config.wip_file }
  let(:repo) { Grit::Repo.new(retter_config.retter_home.to_s) }
  let(:article) { '今日の記事' }

  before do
    Grit::Repo.init retter_config.retter_home.to_s

    Retter.stub!(:config) { retter_config }
    command.stub!(:say) { true }
    wip_file.open('w') {|f| f.puts article }
    command.rebind
  end

  context 'with no options' do
    before do
      command.should_receive(:invoke_after).with(:commit)
      command.commit
    end

    it { repo.commits.first.message.should == 'Retter commit' }
  end

  context 'with silent option' do
    before do
      command.stub!(:options) { {silent: true} }
      command.should_not_receive(:invoke_after)
    end

    it { command.commit.should }
  end
end
