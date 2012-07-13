# coding: utf-8

require 'spec_helper'

describe 'Retter::Command#clean', clean: :all do
  let(:cache_path) { %(#{Retter::Site.config.cache.cache_path}/*) }

  before do
    write_to_wip_file 'hi'

    invoke_command :rebind
    flunk if Dir.glob(cache_path).empty?

    invoke_command :clean
  end

  subject { Dir.glob(cache_path) }

  it { should be_empty }
end
