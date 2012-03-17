# coding: utf-8

require 'spec_helper'

describe 'Retter::Command#rebind', clean: :all do
  context 'first post' do
    let(:date_str) { '20110101' }
    let(:date) { Date.parse(date_str) }
    let(:date_file) { retter_config.retter_file(date) }
    let(:date_html) { retter_config.entry_file(date) }
    let(:article) { <<-EOM }
# 朝11時

おはようございます

# 夜1時

おやすみなさい
    EOM

    before do
      stub_time date_str

      wip_file.open('w') {|f| f.puts article }

      command.should_receive(:invoke_after).with(:bind)
      command.should_receive(:invoke_after).with(:rebind)
      command.rebind
    end

    describe 'wip file' do
      specify 'wip file should be removed' do
        wip_file.should_not be_exist
      end
    end

    describe 'index.html' do
      let(:index_html) { retter_config.index_file.read }

      it { texts_of(index_html, 'article p').should include('おはようございます') }
      it { texts_of(index_html, 'article h1.date').should == %w(2011-01-01) }
      it { texts_of(index_html, 'article h1').should == %w(2011-01-01 朝11時 夜1時) }
    end

    describe 'entries.html' do
      let(:entries_html) { retter_config.entries_file.read }

      it { texts_of(entries_html, 'a.entry').first.should == '2011-01-01' }
      it { texts_of(entries_html, 'a.title').should == %w(朝11時 夜1時) }
    end

    describe 'entry.html' do
      let(:entry_html) { retter_config.entry_file(date).read }

      it { texts_of(entry_html, 'article p').should == %w(おはようございます おやすみなさい) }
      it { texts_of(entry_html, 'article h1.date').should == %w(2011-01-01) }
      it { texts_of(entry_html, 'article h1').should == %w(2011-01-01 朝11時 夜1時) }
    end

    describe 'entry part(first)' do
      let(:part_html) { retter_config.entry_dir(date).join('a0.html').read }

      describe 'body' do
        subject { texts_of(part_html, 'article p') }

        it { should include('おはようございます') }
        it { should_not include('おやすみなさい') }
      end

      describe 'date' do
        subject { texts_of(part_html, 'article h1.date') }

        it { should == %w(2011-01-01) }
      end

      describe 'headings' do
        subject { texts_of(part_html, 'article h1') }

        it { should include('朝11時') }
        it { should_not include('夜1時') }
      end
    end

    describe 'entry part(last)' do
      let(:part_html) { retter_config.entry_dir(date).join('a1.html').read }

      describe 'body' do
        subject { texts_of(part_html, 'article p') }

        it { should include('おやすみなさい') }
        it { should_not include('おはようございます') }
      end

      describe 'date' do
        subject { texts_of(part_html, 'article h1.date') }

        it { should == %w(2011-01-01) }
      end

      describe 'headings' do
        subject { texts_of(part_html, 'article h1') }

        it { should include('夜1時') }
        it { should_not include('朝11時') }
      end
    end
  end

  context 'includes code block' do
    let(:index_html) { retter_config.index_file.read }
    let(:article) { <<-EOM }
# コードを書きました

```ruby
sleep 1000
```
    EOM

    before do
      wip_file.open('w') {|f| f.puts article }
    end

    context 'use Pygments' do
      before do
        retter_config.stub!(:renderer).and_return(Retter::Renderers::PygmentsRenderer)
        command.rebind
      end

      specify 'code should be highlighted' do
        nokogiri(index_html).search('.highlight').should_not be_empty
      end
    end

    context 'use CodeRay' do
      before do
        retter_config.stub!(:renderer).and_return(Retter::Renderers::CodeRayRenderer)
        command.rebind
      end

      specify 'code should be highlighted' do
        nokogiri(index_html).search('.code').should_not be_empty
      end
    end
  end

  context 'with silent option' do
    before do
      wip_file.open('w') {|f| f.puts 'article' }

      command.stub!(:options) { {silent: true} }
    end

    specify 'rebind callback should not invoked' do
      command.should_not_receive(:invoke_after)

      command.rebind
    end
  end
end
