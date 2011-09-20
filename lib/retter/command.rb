# coding: utf-8

class Retter::Command < Thor
  map '-v' => 'version'

  desc 'edit', 'Open $EDITOR. Write an article with Markdown.'
  method_options date: :string, silent: :boolean
  def edit
    system config.editor, detected_retter_file.to_s

    invoke_after :edit unless options[:silent]
  end

  default_task :edit

  desc 'preview', 'Preview the draft article (browser will open).'
  method_options date: :string
  def preview
    preview = Retter::Stationery.previewer(config, detected_date)

    preview.print
    Launchy.open preview.file_path.to_s
  end

  desc 'open', 'Open your (static) site top page (browser will open).'
  def open
    Launchy.open config.index_file.to_s
  end

  desc 'rebind', 'Bind the draft article, re-generate all html pages.'
  method_options silent: :boolean
  def rebind
    binder = Retter::Stationery.binder(config)

    binder.commit_wip_file
    binder.rebind!

    unless options[:silent]
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
    working_dir = config.retter_home.to_s
    git = Grit::Repo.new(working_dir)
    Dir.chdir working_dir

    say git.add(working_dir), :green
    say git.commit_all('Retter commit'), :green

    invoke_after :commit unless options[:silent]
  end

  desc 'home', 'Open a new shell in $RETTER_HOME'
  def home
    Dir.chdir config.retter_home.to_s

    system %(PS1="(retter) " #{config.shell})
    say 'bye', :green
  end

  desc 'new', 'Create a new site'
  def new; end

  desc 'usage', 'Show usage.'
  def usage
    say Retter::Command.usage, :green
  end

  desc 'version', 'Show version.'
  def version
    say "Retter version #{Retter::VERSION}"
  end

  private

  def detected_retter_file
    if options[:date]
      config.retter_file(Date.parse(options[:date]))
    else
      todays_file = config.retter_file(Date.today)
      todays_file.exist? ? todays_file : config.wip_file
    end
  end

  def detected_date
    options[:date] ? Date.parse(options[:date]) : Date.today
  end

  def config
    @retter_config ||= Retter::Config.new(ENV)
  rescue Retter::EnvError
    say 'Set $RETTER_HOME and $EDITOR, first.', :red
    say Retter::Command.usage, :green
    exit 1
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
