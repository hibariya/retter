# coding: utf-8

require File.dirname(__FILE__) + '/../spec_helper'

describe 'Retter::Command#commit', clean: :all do
  let(:command) { Retter::Command.new }
  let(:wip_file) { retter_config.wip_file }
  let(:repo) { Grit::Repo.new(retter_config.retter_home.to_s) }
  let(:article) { '今日の記事' }

  before do
    Grit::Repo.init retter_config.retter_home.to_s

    command.stub!(:config) { retter_config }
    wip_file.open('w') {|f| f.puts article }
    command.rebind

    command.commit
  end

  it { repo.commits.first.message.should == 'Retter commit' }
end
