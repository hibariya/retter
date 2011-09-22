# coding: utf-8

require File.dirname(__FILE__) + '/../spec_helper'

describe 'Retter::Command#callback', clean: :all do
  let(:command) { Retter::Command.new }

  before do
    command.stub!(:config) { retter_config }

    retter_config.after(:edit) { commit }
    command.should_receive(:commit).and_return(true)

    command.stub!(:options) { {after: :edit} }
  end

  it { command.callback.should }
end
