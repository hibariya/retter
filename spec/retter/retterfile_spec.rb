require 'spec_helper'

describe Retter::Retterfile do
  describe Retter::Retterfile::Context::ConfigMethods do
    let(:config)        { ActiveSupport::OrderedOptions.new }
    let(:proc_whatever) { -> { 'whatever' } }

    before do
      config.extend Retter::Retterfile::Context::ConfigMethods
    end

    describe '#after' do
      before do
        config.after :whatever, &proc_whatever
      end

      subject { config.after(:whatever) }

      it { should == proc_whatever }
    end

    describe '#publisher' do
      before do
        config.publisher &proc_whatever
      end

      subject { config.publisher }

      it { should == proc_whatever }
    end
  end
end
