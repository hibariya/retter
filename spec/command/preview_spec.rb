# coding: utf-8

require File.dirname(__FILE__) + '/../spec_helper'

describe 'Retter::Command#preview', clean: :all do
  let(:command) { Retter::Command.new }
  let(:preview) { retter_config.retter_home.join('.preview.html').read }
  let(:wip_file) { retter_config.wip_file }
  let(:date_file) { retter_config.retter_file(Date.parse(date), '.md') }

  before do
    command.stub!(:config) { retter_config }
  end

  context 'no options' do
    let(:article) { 'w00t!' }

    before do
      wip_file.open('w') {|f| f.puts article }
      Launchy.stub!(:open).with(anything)

      command.preview
    end

    it { preview.should =~ /<body.*#{article}.*\/body>/mi }
  end

  context 'with date' do
    let(:article) { 'おはようございます' }
    let(:date) { '20110101' }

    before do
      wip_file.open('w') {|f| f.puts 'おやすみなさい' }
      date_file.open('w') {|f| f.puts article }
      Launchy.stub!(:open).with(anything)

      command.preview
    end

    it { preview =~ /#{article}/mi }
    it { preview !~ /おやすみなさい/mi }
  end
end
