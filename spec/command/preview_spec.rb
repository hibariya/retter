# coding: utf-8

require 'spec_helper'
require 'launchy'

describe 'Retter::Command#preview', clean: :all do
  def preview_html
    retter_config.retter_home.join('.preview.html').read
  end

  before do
    Launchy.should_receive(:open).with(anything)
  end

  context 'no options' do
    before do
      wip_file.open('w') {|f| f.puts 'w00t!' }

      command.preview
    end

    subject { texts_of(preview_html, 'article p') }

    it { should include 'w00t!' }
  end

  context 'with date option' do
    let(:date_str) { '20110101' }
    let(:date_file) { Retter.entries.retter_file(Date.parse(date_str)) }

    before do
      wip_file.open('w') {|f| f.puts 'w00t!' }
      date_file.open('w') {|f| f.puts 'preview me' }

      command.stub!(:options) { {date: date_str} }

      command.preview
    end

    subject { texts_of(preview_html, 'article p') }

    it { should_not include 'w00t!' }
    it { should include 'preview me' }
  end
end
