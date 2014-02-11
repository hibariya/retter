require 'spec_helper'

describe Retter::Deprecated do
  describe Retter::Deprecated::Retter do
    specify do
      expect(Retter::Deprecated).to receive(:warn).with('Retter::Markdown', 'Retter::StaticSite::Markdown')
      expect(Retter::Markdown).to eq Retter::StaticSite::Markdown
    end
  end

  describe Retter::Deprecated::Site do
    specify do
      expect(Retter::Deprecated).to receive(:removed_warn).with('Retter::Site#author')
      expect(Retter::Site.author).to be_nil
    end
  end

  describe Retter::Deprecated::Entry::Article do
    let(:article) { Retter::Entry::Article.new(body: 'hi') }

    describe '#to_s' do
      specify do
        expect(Retter::Deprecated).to receive(:warn).with('Retter::Entry::Article#to_s', 'Retter::Entry::Article#body')
        expect(article.to_s).to eq 'hi'
      end
    end

    describe '#actual?' do
      specify do
        expect(Retter::Deprecated).to receive(:removed_warn).with('Retter::Entry::Article#actual?')

        expect(article.actual?).to be_true
      end
    end
  end

  describe Retter::Deprecated::CLI::Command do
    let(:command) { double(:command) }

    before do
      class << command
        def self.desc(*) end
        def self.method_options(*) end

        include Retter::Deprecated::CLI::Command
      end

      allow(command).to receive(:invoke).with(anything)
    end

    specify 'rebind invokes build' do
      expect(Retter::Deprecated).to receive(:warn).with(:rebind, :build, '(command)')
      command.rebind

      expect(command).to have_received(:invoke).with(:build)
    end

    specify 'bind invokes build' do
      expect(Retter::Deprecated).to receive(:warn).with(:bind, :build, '(command)')
      command.bind

      expect(command).to have_received(:invoke).with(:build)
    end

    specify 'commit does not affect' do
      expect(Retter::Deprecated).to receive(:removed_warn).with(:commit, :build, '(command)')
      command.commit
    end

    specify 'home does not work' do
      expect(Retter::Deprecated).to receive(:removed_warn).with(:home, nil, '(command)')
      command.home
    end

    specify 'usage does not work' do
      expect(Retter::Deprecated).to receive(:removed_warn).with(:usage, :help, '(command)')
      command.usage
    end

    specify 'open does not work' do
      expect(Retter::Deprecated).to receive(:removed_warn).with(:open, :preview, '(command)')
      command.open
    end

    specify 'clean does not affect' do
      expect(Retter::Deprecated).to receive(:removed_warn).with(:clean, nil, '(command)')
      command.clean
    end
  end

  describe Retter::Deprecated::Retterfile::Context do
    let(:retterfile_context) { double(:context) }

    before do
      class << retterfile_context
        include Retter::Deprecated::Retterfile::Context
      end
    end

    specify 'markup does not affect' do
      expect(Retter::Deprecated).to receive(:removed_warn).with('allow_binding', nil, 'Retterfile')

      retterfile_context.allow_binding %w(hi)
    end
  end
end
