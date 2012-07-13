# coding: utf-8

require 'spec_helper'
require 'grit'

describe 'Retter::Command#commit', clean: :all do
  let(:retter_home) { Retter::Site.config.retter_home }
  let(:repo) { Grit::Repo.new(retter_home) }
  let(:article) { '今日の記事' }

  before do
    command.stub!(:say) { true }

    write_to_wip_file article

    invoke_command :rebind

    Grit::Repo.init retter_home.to_path
  end

  context 'with no options' do
    before do
      command.should_receive(:after_callback).with(:commit)

      invoke_command :commit
    end

    subject { repo.commits.first }

    its(:message) { should == 'Retter commit' }
  end

  context 'with silent option' do
    specify 'callback should not called' do
      command.should_not_receive(:after_callback).with(:commit)

      invoke_command :commit, silent: :true
    end
  end
end
