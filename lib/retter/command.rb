# coding: utf-8

class Retter::Command < Thor
  include Retter::Stationery

  map '-v' => :version,
      '-e' => :edit,
      '-p' => :preview,
      '-o' => :open,
      '-r' => :rebind,
      '-b' => :bind

  desc 'edit', 'Open $EDITOR. Write an article with Markdown.'
  method_options date: :string, key: :string, silent: :boolean
  def edit(identifier = options[:date] || options[:key])
    entry = entries.detect_by_string(identifier)

    system "#{config.editor} #{entry.path}"

    invoke_after :edit unless silent?
  end

  default_task :edit

  desc 'preview', 'Preview the draft article (browser will open).'
  method_options date: :string, key: :string
  def preview(identifier = options[:date] || options[:key])
    entry = entries.detect_by_string(identifier)

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

  desc 'bind', 'Alias of rebind'
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

  desc 'list', 'List retters'
  def list
    entries.each_with_index do |entry, n|
      say "[e#{n}] #{entry.date}"
      say "  #{entry.articles.map(&:title).join(', ')}"
      say
    end
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
  # 1. Startup
  cd /path/to/dir
  retter new my_sweet_diary
  echo "export EDITOR=vim" >> ~/.zshenv # retter requires $EDITOR.
  echo "export RETTER_HOME=/path/to/my_sweet_diary" >> ~/.zshenv
  . ~/.zshenv

  # 2. Write a article
  retter         # $EDITOR will open. Write an article with Markdown.
  retter preview # Preview the draft article (browser will open).

  # 3. Publish
  retter bind    # bind the draft article, re-generate all html pages.
  retter commit  # shortcut of "cd $RETTER_HOME; git add .; git commit -m 'Retter commit'"
  cd $RETTER_HOME
  git push [remote] [branch] # or sftp, rsync, etc...

  # Specific date
  retter edit 20110101
  retter preview 20110101

  # Specific file
  retter edit today.md
  retter edit 20110101.md
  retter preview 20110101.md

  # Browse entry list.
  retter list

  output examples:
    [e0] 2011-11-07
    entry3 title

    [e1] 2011-10-25
    entry2 title

    [e2] 2011-10-22
    entry1 title

  to edit by keyword. run following command:
    retter edit e1

  # Browse offline.
  retter open    # Open your (static) site top page (browser will open).

  See also: https://github.com/hibariya/retter
    EOM
  end
end
