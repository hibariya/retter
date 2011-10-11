# coding: utf-8

class Retter::Generator::Creator < Retter::Generator::Base
  def git_init
    Grit::Repo.init "#{Dir.pwd}/#{name}"
  end

  def notice_how_to_use
    editor = ENV['EDITOR']

    say "-- Thanks for flying Retter :-> --\n", :green
    say <<-EOM, :green
Setting $EDITOR:
  retter *requires* $EDITOR variable.
  example:
    echo "export EDITOR=vim" >> ~/.zshenv # or ~/.bash_profile
    . ~/.zshenv
    EOM

    say "  Current your $EDITOR is #{editor ? editor : 'undefined'}.\n", :red

    say <<-EOM, :green
Setting $RETTER_HOME:
  You can use retter command anywhere, If you set $RETTER_HOME variable.
  example:
    echo "export RETTER_HOME=#{Dir.pwd}/#{name}" >> ~/.zshenv
    ...

See also:
  retter usage
  retter help
    EOM
  end
end
