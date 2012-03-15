# coding: utf-8

require 'spec_helper'

describe 'Retter::Command#preview', clean: :all do
  let(:command) { Retter::Command.new }
  let(:preview) { retter_config.retter_home.join('.preview.html').read }
  let(:wip_file) { retter_config.wip_file }
  let(:date_file) { retter_config.retter_file(Date.parse(date_str)) }

  context 'no options' do
    let(:article) { 'w00t!' }

    before do
      wip_file.open('w') {|f| f.puts article }

      Launchy.stub!(:open).with(anything)

      command.preview
    end

    subject { texts_of(preview, 'article p') }

    it { should == [article] }
  end

  context 'with date' do
    let(:article) { 'おはようございます' }
    let(:date_str) { '20110101' }

    before do
      wip_file.open('w') {|f| f.puts 'おやすみなさい' }
      date_file.open('w') {|f| f.puts article }

      Launchy.stub!(:open).with(anything)
      command.stub!(:options) { {date: date_str} }

      command.preview
    end

    subject { texts_of(preview, 'article p') }

    it { should_not be_include('おやすみなさい') }
    it { should be_include(article) }
  end
end
