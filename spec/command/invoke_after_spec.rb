# coding: utf-8

require 'spec_helper'

describe 'Retter::Command#invoke_after', clean: :all do
  context 'invoke with proc' do
    before do
      retter_config.after(:edit) { commit }
    end

    specify 'callback should called' do
      command.should_receive(:commit)

      command.edit
    end
  end

  context 'invoke with symbol' do
    before do
      retter_config.after(:edit, :commit)
    end

    specify 'callback should called' do
      command.should_receive(:invoke).with(:commit)

      command.edit
    end
  end
end
