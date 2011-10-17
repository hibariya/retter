# coding: utf-8

class Retter::Command < Thor
  include Retter::Stationery

  map '-v' => :version,
      '-e' => :edit,
      '-p' => :preview,
      '-o' => :open,
      '-r' => :rebind,
      '-b' => :bind,
      '-h' => :home

  desc 'edit', 'Open $EDITOR. Write an article with Markdown.'
  method_options date: :string, silent: :boolean
  def edit
    entry = entries.detect_by_date_string(options[:date])

    system config.editor, entry.path

    invoke_after :edit unless silent?
  end

  default_task :edit

  desc 'preview', 'Preview the draft article (browser will open).'
  method_options date: :string
  def preview
    entry = entries.detect_by_date_string(options[:date])

    preprint.print entry

    Launchy.open preprint.path
  end

  desc 'open', 'Open your (static) site top page (browser will open).'
  def open
    Launchy.open pages.index.path
  end

  desc 'rebind', 'Bind the draft article, re-generate all html pages.'
  method_options silent: :boolean
  def rebind
    entries.commit_wip_entry!

    pages.bind!

    unless silent?
      invoke_after :bind
      invoke_after :rebind
    end
  end

  desc 'bind', 'Re-bind the draft article, re-generate all html pages.'
  method_options silent: :boolean
  alias_method :bind, :rebind

  desc 'commit', "cd $RETTER_HOME && git add . && git commit -m 'Retter commit'"
  method_options silent: :boolean
  def commit
    repository.open do |git|
      say git.add(config.retter_home), :green
      say git.commit_all('Retter commit'), :green
    end

    invoke_after :commit unless silent?
  end

  desc 'home', 'Open a new shell in $RETTER_HOME'
  def home
    Dir.chdir config.retter_home.to_s

    system %(PS1="(retter) " #{config.shell})
    say 'bye', :green
  end

  desc 'callback', 'Call a callback process only'
  method_options after: :string
  def callback
    invoke_after options[:after].intern
  end

  desc 'new', 'Create a new site'
  def new; end

  desc 'gen', 'Generate initial files'
  def gen; end

  desc 'usage', 'Show usage.'
  def usage
    say Retter::Command.usage, :green
  end

  desc 'version', 'Show version.'
  def version
    say "Retter version #{Retter::VERSION}"
  end

  private

  def silent?
    !options[:silent].nil?
  end

  def invoke_after(name)
    callback = config.after(name)
    return unless callback

    case callback
    when Proc
      instance_eval &callback
    when Symbol
      invoke callback
    else
      raise ArgumentError
    end
  end

  def self.usage
    <<-EOM
Usage:
  # Startup
  cd /path/to/dir
  retter new my_sweet_diary
  echo "export EDITOR=vim" >> ~/.zshenv # retter requires $EDITOR.
  echo "export RETTER_HOME=/path/to/my_sweet_diary" >> ~/.zshenv
  . ~/.zshenv

  # Write a article
  retter         # $EDITOR will open. Write an article with Markdown.
  retter preview # Preview the draft article (browser will open).

  # Publish
  retter bind    # bind the draft article, re-generate all html pages.
  retter commit  # shortcut of "cd $RETTER_HOME; git add .; git commit -m 'Retter commit'"
  cd $RETTER_HOME
  git push [remote] [branch] # or sftp, rsync, etc...

  # Specific date
  retter edit --date=20110101
  retter preview --date=20110101

  # Browse offline.
  retter open    # Open your (static) site top page (browser will open).

  See also: https://github.com/hibariya/retter
    EOM
  end
end
