require 'spec_helper'

describe Retter::Initializing do
  let(:root_module) {
    Module.new {
      include Retter::Initializing
    }
  }

  before do
    RSpec::Mocks::TestDouble.extend_onto(root_module, 'ModuleWhatever')
  end

  describe '#process_initialize' do
    let(:plugged_module) {
      Module.new {
        mattr_accessor :initializer_called, :after_initializer_called
      }
    }

    context 'no initializers' do
      before do
        root_module.__send__ :process_initialize
      end

      subject { root_module }

      it { should be_initialized }
    end

    context 'w/ no after_initializer' do
      before do
        plugged_module.class_exec(root_module) do |root_module|
          root_module.on_initialize do |config|
            self.initializer_called = true
          end
        end

        root_module.__send__ :process_initialize
      end

      subject { plugged_module }

      its(:initializer_called) { should be_true }
      its(:after_initializer_called) { should be_nil }
    end

    context 'w/ after_initializer' do
      before do
        plugged_module.class_exec(root_module) do |root_module|
          root_module.on_initialize do |config|
            self.initializer_called = true

            -> { self.after_initializer_called = true }
          end
        end

        root_module.__send__ :process_initialize
      end

      subject { plugged_module }

      its(:initializer_called) { should be_true }
      its(:after_initializer_called) { should be_true }
    end

    context 'already initialized' do
      before do
        root_module.__send__ :process_initialize

        plugged_module.class_exec(root_module) do |root_module|
          root_module.on_initialize do |config|
            self.initializer_called = true

            -> { self.after_initializer_called = true }
          end
        end
      end

      subject { plugged_module }

      its(:initializer_called) { should be_true }
      its(:after_initializer_called) { should be_true }
    end
  end
end
