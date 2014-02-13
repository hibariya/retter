require 'spec_helper'

describe 'retter list' do
  context 'default site', :with_default_site do
    before do
      File.write 'source/retters/20140101.md', <<-DIARY.strip_heredoc
        # First

        Hi, Alice.

        # Second

        Hi, Bob.
      DIARY

      File.write 'source/retters/20140103.md', <<-DIARY.strip_heredoc
        # Third

        Hi, Charlie
      DIARY

      File.write 'source/retters/today.md', <<-DIARY.strip_heredoc
        # Today

        Hi, Present.
      DIARY
    end

    subject { invoke_retter('list') }

    its(:stdout) { should == <<-LISTING.strip_heredoc }
      [e0] 2014-01-01
        First
        Second
      [e1] 2014-01-03
        Third
      [e2] #{Date.today.strftime('%Y-%m-%d')}
        Today
    LISTING
  end

  context 'multi branch', :with_multi_branch_site do
    before do
      Retter::StaticSite::Repository.new '.' do |repo|
        repo.checkout 'source' do
          File.write 'source/retters/20140101.md', <<-DIARY.strip_heredoc
            # First

            Hi, Alice.
          DIARY
        end

        invoke_retter('build').should be_exit_successfully
      end
    end

    subject { invoke_retter('list') }

    its(:stdout) { should == <<-LISTING.strip_heredoc }
      [e0] 2014-01-01
        First
    LISTING
  end
end
