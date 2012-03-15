# coding: utf-8

require 'spec_helper'

describe 'Retter::Command#invoke_after', clean: :all do
  context 'invoke with proc' do
    before do
      retter_config.after(:edit) { commit }
      command.should_receive(:commit).and_return(true)
    end

    it { command.edit.should }
  end

  context 'invoke with symbol' do
    before do
      retter_config.after(:edit, :commit)
      command.should_receive(:invoke).with(:commit).and_return(true)
    end

    it { command.edit.should }
  end
end
