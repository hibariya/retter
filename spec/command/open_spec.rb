# coding: utf-8

require File.dirname(__FILE__) + '/../spec_helper'

describe 'Retter::Command#open', clean: :all do
  let(:command) { Retter::Command.new }
  let(:wip_file) { retter_config.wip_file }

  before do
    command.stub!(:config) { retter_config }
  end

  it 'should be open application' do
    Launchy.should_receive(:open).with(retter_config.index_file.to_s)
    command.open
  end
end
