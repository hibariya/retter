# coding: utf-8

require 'spec_helper'

describe 'Retter::Command#rebind', clean: :all do
  context 'first post' do
    let(:date_str)  { '2011/01/01' }
    let(:article)   { <<-EOM }
# 朝11時

おはようございます

# 夜1時

おやすみなさい
    EOM

    before do
      time_travel_to date_str

      write_to_wip_file article

      command.should_receive(:invoke_after).with(:bind)
      command.should_receive(:invoke_after).with(:rebind)

      invoke_command :rebind
    end

    describe 'wip file' do
      specify 'wip file should be removed' do
        wip_file.should_not be_exist
      end
    end

    describe 'index.html' do
      let(:index_html) { generated_file('index.html').read }

      it { texts_of(index_html, 'article p').should       include 'おはようございます' }
      it { texts_of(index_html, 'article h1.date').should == %w(2011-01-01) }
      it { texts_of(index_html, 'article h1').should      == %w(2011-01-01 朝11時 夜1時) }
    end

    describe 'entries.html' do
      let(:entries_html) { generated_file('entries.html').read }

      it { texts_of(entries_html, 'a.entry').first.should == '01/01' }
      it { texts_of(entries_html, 'a.article').should     == %w(朝11時 夜1時) }
    end

    describe 'entry.html' do
      let(:entry_html) { entry_html_file(date_str).read }

      it { texts_of(entry_html, 'article p').should       == %w(おはようございます おやすみなさい) }
      it { texts_of(entry_html, 'article h1.date').should == %w(2011-01-01) }
      it { texts_of(entry_html, 'article h1').should      == %w(2011-01-01 朝11時 夜1時) }
    end

    describe 'article (first)' do
      let(:article_html) { article_html_file(date_str, 'a0').read }

      describe 'body' do
        subject { texts_of(article_html, 'article p') }

        it { should     include 'おはようございます' }
        it { should_not include 'おやすみなさい' }
      end

      describe 'date' do
        subject { texts_of(article_html, 'article h1.date') }

        it { should == %w(2011-01-01) }
      end

      describe 'headings' do
        subject { texts_of(article_html, 'article h1') }

        it { should     include '朝11時' }
        it { should_not include '夜1時' }
      end
    end

    describe 'article (last)' do
      let(:article_html) { article_html_file(date_str, 'a1').read }

      describe 'body' do
        subject { texts_of(article_html, 'article p') }

        it { should     include 'おやすみなさい' }
        it { should_not include 'おはようございます' }
      end

      describe 'date' do
        subject { texts_of(article_html, 'article h1.date') }

        it { should == %w(2011-01-01) }
      end

      describe 'headings' do
        subject { texts_of(article_html, 'article h1') }

        it { should     include '夜1時' }
        it { should_not include '朝11時' }
      end
    end
  end

  context 'article includes code block' do
    let(:index_html) { generated_file('index.html').read }
    let(:article)    { <<-EOM }
# コードを書きました

```ruby
sleep 1000
```
    EOM

    before do
      write_to_wip_file article
    end

    context 'use Pygments' do
      before do
        Retter::Site.config.renderer Retter::Renderers::PygmentsRenderer

        invoke_command :rebind
      end

      specify 'code should be highlighted' do
        nokogiri(index_html).search('.highlight').should_not be_empty
      end
    end

    context 'use CodeRay' do
      before do
        Retter::Site.config.renderer Retter::Renderers::CodeRayRenderer

        invoke_command :rebind
      end

      specify 'code should be highlighted' do
        nokogiri(index_html).search('.code').should_not be_empty
      end
    end
  end

  context 'use custom markup' do
    let(:index_html)    { generated_file('index.html').read }
    let(:custom_markup) { Object.new.tap {|o| o.define_singleton_method(:render, &:upcase) } }

    before do
      Retter::Site.config.markup custom_markup

      write_to_wip_file 'hi'

      invoke_command :rebind
    end

    after do
      Retter::Entries.instance_variable_set :@markup, nil
    end

    subject { texts_of(index_html, 'article p') }

    it { should include 'HI' }
  end

  context 'with silent option' do
    before do
      write_to_wip_file 'article'
    end

    specify 'rebind callback should not invoked' do
      command.should_not_receive(:invoke_after)

      invoke_command :rebind, silent: true
    end
  end

  context 'skipping some singleton pages binding' do
    let(:index_html)   { generated_file('index.html') }
    let(:profile_html) { generated_file('profile.html') }
    let(:entries_html) { generated_file('entries.html') }
    let(:feed_file)    { generated_file('feed.rss') }

    before do
      index_html.unlink

      invoke_command :edit
    end

    context 'skipping all' do
      before do
        invoke_command :rebind do |config|
          config.allow_binding :none
        end
      end

      it { profile_html.should_not be_exist }
      it { entries_html.should_not be_exist }
      it { feed_file.should_not    be_exist }
      it { index_html.should       be_exist }
    end

    context 'skipping only :feed' do
      before do
        invoke_command :rebind do |config|
          config.allow_binding [:profile, :entries]
        end
      end

      it { profile_html.should  be_exist }
      it { entries_html.should  be_exist }
      it { feed_file.should_not be_exist }
      it { index_html.should    be_exist }
    end
  end

  context 'with link or image' do
    let(:index_html) { generated_file('index.html').read }
    let(:elements)   { nokogiri(index_html) }

    before do
      write_to_wip_file article

      invoke_command :rebind
    end

    describe 'a href="//example.com/foo/bar"' do
      let(:article) { '[title](//example.com/foo/bar)' }

      it { elements.search("a[href='//example.com/foo/bar']").should_not be_empty }
    end

    describe 'img src="//example.com/foo/bar.png"' do
      let(:article) { '![title](//example.com/foo/bar.png)' }

      it { elements.search("img[src='//example.com/foo/bar.png']").should_not be_empty }
    end

    describe 'a href="/foo/bar"' do
      let(:article) { '[title](/foo/bar)' }

      it { elements.search("a[href='./foo/bar']").should_not be_empty }
    end

    describe 'img src="/foo/bar.png"' do
      let(:article) { '![title](/foo/bar.png)' }

      it { elements.search("img[src='./foo/bar.png']").should_not be_empty }
    end

    describe 'a href="./foo/bar"' do
      let(:article) { '[title](./foo/bar)' }

      it { elements.search("a[href='./foo/bar']").should_not be_empty }
    end

    describe 'img src="./foo/bar.png"' do
      let(:article) { '![title](./foo/bar.png)' }

      it { elements.search("img[src='./foo/bar.png']").should_not be_empty }
    end

    describe 'a href="../foo/bar"' do
      let(:article) { '[title](../foo/bar)' }

      it { elements.search("a[href='../foo/bar']").should_not be_empty }
    end

    describe 'img src="../foo/bar.png"' do
      let(:article) { '![title](../foo/bar.png)' }

      it { elements.search("img[src='../foo/bar.png']").should_not be_empty }
    end
  end
end
