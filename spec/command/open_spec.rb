# coding: utf-8

require 'spec_helper'
require 'launchy'

describe 'Retter::Command#open', clean: :all do
  specify 'should be open application' do
    Launchy.should_receive(:open).with(Retter.config.retter_home.join('index.html').to_path)

    command.open
  end
end
