# coding: utf-8

require 'spec_helper'
require 'grit'

describe 'Retter::Command#commit', clean: :all do
  let(:repo) { Grit::Repo.new(Retter.config.retter_home) }
  let(:article) { '今日の記事' }

  before do
    command.stub!(:say) { true }
    wip_file.open('w') {|f| f.puts article }
    command.rebind

    Grit::Repo.init Retter.config.retter_home.to_path
  end

  context 'with no options' do
    before do
      command.should_receive(:invoke_after).with(:commit)

      command.commit
    end

    subject { repo.commits.first }

    its(:message) { should == 'Retter commit' }
  end

  context 'with silent option' do
    before do
      command.stub!(:options) { {silent: true} }
    end

    specify 'callback should not called' do
      command.should_not_receive(:invoke_after)

      command.commit
    end
  end
end
