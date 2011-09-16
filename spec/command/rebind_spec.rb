# coding: utf-8

require File.dirname(__FILE__) + '/../spec_helper'

describe 'Retter::Command#rebind', clean: :all do
  let(:command) { Retter::Command.new }
  let(:wip_file) { retter_config.wip_file }
  let(:date_file) { retter_config.retter_file(Date.parse(date_str)) }
  let(:date_html) { retter_config.entry_file(Date.parse(date_str)) }

  before do
    command.stub!(:config) { retter_config }
  end

  context 'first post' do
    let(:date_str) { '20110101' }
    let(:article) { <<-EOM }
# 朝11時

おはようございます

# 夜1時

おやすみなさい
    EOM

    before do
      wip_file.open('w') {|f| f.puts article }
      Date.stub!(:today).and_return(Date.parse(date_str))

      command.should_receive(:invoke_after).with(:bind)
      command.should_receive(:invoke_after).with(:rebind)
      command.rebind
    end

    describe 'today.md' do
      it { wip_file.should_not be_exist }
    end

    describe 'index.html' do
      let(:index_html) { retter_config.index_file.read }

      it { texts_of(index_html, '.entry p').should be_include('おはようございます') }
      it { texts_of(index_html, '.entry h1.date').should == %w(2011/01/01) }
      it { texts_of(index_html, '.entry h1').should == %w(2011/01/01 朝11時 夜1時) }
    end

    describe 'entries.html' do
      let(:entries_html) { retter_config.entries_file.read }

      it { texts_of(entries_html, 'a.entry').first.should == '2011/01/01' }
      it { texts_of(entries_html, 'a.title').should == %w(朝11時 夜1時) }
    end

    describe 'entry.html' do
      let(:entry_html) { retter_config.entry_file(Date.parse(date_str)).read }

      it { texts_of(entry_html, '.entry p').should be_include('おはようございます') }
      it { texts_of(entry_html, '.entry h1.date').should == %w(2011/01/01) }
      it { texts_of(entry_html, '.entry h1').should == %w(2011/01/01 朝11時 夜1時) }
    end
  end

  context 'with silent option' do
    before do
      wip_file.open('w') {|f| f.puts 'article' }
      command.stub!(:options) { {silent: true} }

      command.should_not_receive(:invoke_after)
    end

    it { command.rebind.should }
  end
end
