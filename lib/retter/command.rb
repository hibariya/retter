# coding: utf-8

class Retter::Command < Thor
  desc 'edit', 'Open $EDITOR. Write an article with Markdown.'
  method_options date: :string
  def edit
    system config.editor, detected_retter_file.to_s
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
  def rebind
    binder = Retter::Stationery.binder(config)

    binder.commit_wip_file
    binder.rebind!
  end

  desc 'bind', 'Re-bind the draft article, re-generate all html pages.'
  alias_method :bind, :rebind

  desc 'commit', "cd $RETTER_HOME && git add . && git commit -m 'Retter commit'"
  def commit
    working_dir = config.retter_home.to_s
    git = Grit::Repo.new(working_dir)
    Dir.chdir working_dir

    git.add working_dir
    git.commit_all 'Retter commit'
  end

  desc 'new', 'Create a new site'
  def new
  end

  desc 'usage', 'Show usage.'
  def usage
    say Retter::Command.usage, :green
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

  def self.usage
    <<-EOM
Usage:
  # startup
  cd /path/to/dir
  retter new my_sweet_diary
  echo "export EDITOR=vim" >> ~/.zshenv # retter requires $EDITOR.
  echo "export RETTER_HOME=/path/to/my_sweet_diary" >> ~/.zshenv
  . ~/.zshenv

  # write a article, and publish.
  retter         # $EDITOR will open. Write an article with Markdown.
  retter preview # Preview the draft article (browser will open).
  retter bind    # bind the draft article, re-generate all html pages.
  git add .
  git commit -m 'commit message'
  git push [remote] [branch]

  # edit specific date article.
  retter edit --date=20110101
  retter preview --date=20110101

  # browse offline.
  retter open    # Open your (static) site top page (browser will open).

  See also: https://github.com/hibariya/retter
    EOM
  end
end
