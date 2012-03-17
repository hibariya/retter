# coding: utf-8

require 'spec_helper'
require 'launchy'

describe 'Retter::Command#open', clean: :all do
  specify 'should be open application' do
    Launchy.should_receive(:open).with(retter_config.index_file.to_s)

    command.open
  end
end
