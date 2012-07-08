# coding: utf-8

require 'spec_helper'
require 'launchy'

describe 'Retter::Command#open', clean: :all do
  specify 'should be open application' do
    Launchy.should_receive(:open).with(generated_file('index.html').to_path)

    invoke_command :open
  end
end
