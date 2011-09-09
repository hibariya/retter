# coding: utf-8

class Retter::Command < Thor
  desc 'edit', 'Edit current entry with $EDITOR'
  method_options date: :string
  def edit
    system config.editor, detected_retter_file.to_s
  end

  default_task :edit

  desc 'preview', 'Preview current entry'
  method_options date: :string
  def preview
    preview = Retter::Stationery.previewer(detected_date, config)

    preview.print
    Launchy.open preview.file_path.to_s
  end

  desc 'open', 'Open site statically'
  def open
    Launchy.open config.index_file.to_s
  end

  desc 'rebind', 'Re generate site pages'
  def rebind
    binder = Retter::Stationery.binder(config)

    binder.commit_wip_file
    binder.rebind!
  end

  desc 'bind', 'Generate site pages'
  alias_method :bind, :rebind

  desc 'new', 'Create new site'
  def new
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
    say <<-EOM, :green
usage:
  export EDITOR=`which vim`      # or other editor
  cd /path/to/dir
  retter new my_sweet_diary
  export RETTER_HOME=/path/to/dir/my_sweet_diary
  cd my_sweet_diary
  retter                         # Write the article with markdown, and save.
  retter preview                 # Draft article will be opened in your default browser.
  retter bind                    # Your actual website will be generated.
  bundle exec rackup             # Open your browser, and visit http://localhost:9292/ .
    EOM
    exit 1
  end
end
