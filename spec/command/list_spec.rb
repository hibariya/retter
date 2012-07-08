# coding: utf-8

require 'spec_helper'

describe 'Retter::Command#list', clean: :all do
  context 'happy case' do
    before do
      markdown_file('20110101').open('w') do |f|
        f.puts <<-EOM
# 朝11時

おはようございます

# 夜1時

おやすみなさい
        EOM
      end

      markdown_file('20110222').open('w') do |f|
        f.puts <<-EOM
# 朝11時30分

おはようございます

# 夜1時30分

おやすみなさい
        EOM
      end

      Retter.reset! # XXX
    end

    subject { capture(:stdout) { invoke_command :list }.split(/\n+/) }

    its([0]) { should match /\[e0\]\s+2011\-02\-22/ }
    its([1]) { should match /朝11時30分, 夜1時30分/ }
    its([2]) { should match /\[e1\]\s+2011\-01\-01/ }
    its([3]) { should match /朝11時, 夜1時/ }
  end
end
