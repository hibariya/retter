# coding: utf-8

require 'spec_helper'

describe 'Retter::Command#callback', clean: :all do
  context 'invoke with proc' do
    specify 'callback should called' do
      command.should_receive(:commit)

      invoke_command :callback, after: :edit do |config|
        config.after :edit do
          commit
        end
      end
    end
  end

  context 'invoke with symbol' do
    specify 'callback should called' do
      command.should_receive(:commit)

      invoke_command :callback, after: :edit do |config|
        config.after :edit, :commit
      end
    end
  end
end
