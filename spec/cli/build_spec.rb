require 'spec_helper'

describe 'retter build', :with_test_site do
  let(:today_str) { Date.today.strftime('%Y%m%d') }

  before do
    File.write 'source/retters/20140101.md', <<-DIARY.strip_heredoc
      # First

      Hi, Alice.

      # Second

      Hi, Bob.
    DIARY

    File.write 'source/retters/today.md', <<-DIARY.strip_heredoc
      # Today

      Hi, Present.
    DIARY

    invoke_retter('build').should be_exit_successfully
  end

  # TODO: test when using source branch
  describe 'source files' do
    let(:wip_file)  { Pathname('source/retters/today.md') }
    let(:dest_file) { Pathname("source/retters/#{today_str}.md") }

    specify 'wip file should renamed' do
      wip_file.should_not be_exist
      dest_file.should written
    end
  end

  describe 'publish files' do
    specify 'files are generated successfully' do
      Dir.glob('assets/application-*.css').should be_present

      %W(
        index.html about.html entries.html entries.rss
        entries/20140101.html
        entries/20140101/a0.html
        entries/20140101/a1.html
        entries/#{today_str}.html
        entries/#{today_str}/a0.html
      ).each do |file|
        Pathname(file).should written
      end
    end
  end
end
