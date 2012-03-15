# coding: utf-8

require 'spec_helper'

describe 'Retter::Command#callback', clean: :all do
  before do
    retter_config.after(:edit) { commit }

    command.stub!(:options) { {after: :edit} }
  end

  specify 'callback should called' do
    command.should_receive(:commit)

    command.callback
  end
end
