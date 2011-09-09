# coding: utf-8

require File.dirname(__FILE__) + '/../spec_helper'

describe 'Retter::Command#rebind', clean: :all do
  let(:command) { Retter::Command.new }
  let(:wip_file) { retter_config.wip_file }
  let(:date_file) { retter_config.retter_file(Date.parse(date)) }
  let(:date_html) { retter_config.retter_home.join('entries', "#{date}.html") }

  before do
    command.stub!(:config) { retter_config }
  end

  context 'first post' do
    let(:date) { '20110101' }
    let(:article) { <<-EOM }
# 朝11時

おはようございます

# 夜1時

おやすみなさい
    EOM

    before do
      wip_file.open('w') {|f| f.puts article }
      Date.stub!(:today).and_return(Date.parse(date))

      command.rebind
    end

    describe 'today.md' do
      it { wip_file.should_not be_exist }
    end

    describe 'index.html' do
      subject { Nokogiri::HTML(retter_config.retter_home.join('index.html').read) }

      it { subject.search('body').text.should =~ /おはようございます/ }
      it { subject.search('.entry h1.date').first.text.should be_include('2011/01/01') }
      it { subject.search('.entry h1').map(&:text).map(&:strip).should == %w(2011/01/01 朝11時 夜1時) }
    end

    describe 'entries.html' do
      subject { Nokogiri::HTML(retter_config.retter_home.join('entries.html').read) }

      it { subject.search('a.entry').first.text.should be_include('2011/01/01') }
      it { subject.search('a.title').map(&:text).map(&:strip).should == %w(朝11時 夜1時) }
    end
  end
end
