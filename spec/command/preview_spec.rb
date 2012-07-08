# coding: utf-8

require 'spec_helper'
require 'launchy'

describe 'Retter::Command#preview', clean: :all do
  let(:preview_html) { generated_file('.preview.html').read }

  before do
    Launchy.should_receive(:open).with(anything)
  end

  context 'no options' do
    before do
      write_to_wip_file 'w00t!'

      invoke_command :preview
    end

    subject { texts_of(preview_html, 'article p') }

    it { should include 'w00t!' }
  end

  context 'with date option' do
    let(:date_file) { markdown_file('20110101') }

    before do
      write_to_wip_file 'w00t!'
      date_file.open('w') {|f| f.puts 'preview me' }

      invoke_command :preview, date: '20110101'
    end

    subject { texts_of(preview_html, 'article p') }

    it { should_not include 'w00t!' }
    it { should     include 'preview me' }
  end
end
