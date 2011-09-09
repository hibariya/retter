# coding: utf-8

class Retter::Config
  [:editor, :retter_home, :title, :description, :url, :author].each do |att|
    class_eval <<-EOM
      def #{att}(val = nil)
        val ? @options[:#{att}] = val : @options[:#{att}]
      end
    EOM
  end

  def initialize(env)
    @env, @options = env, {}

    detect_retter_home
    raise Retter::EnvError unless env.values_at('EDITOR', 'RETTER_HOME').all?

    editor env['EDITOR']
    retter_home Pathname.new(env['RETTER_HOME'])
    url 'http://example.com'

    retterfile = retter_home.join('Retterfile')
    instance_eval retterfile.read if retterfile.exist?
  end

  def detect_retter_home
    @env['RETTER_HOME'] = Dir.pwd if File.exist? 'Retterfile'
  end

  def retters_dir
    retter_home.join 'retters/'
  end

  def wip_file
    retters_dir.join 'today.md'
  end

  def retter_file(date)
    retters_dir.join(date ? date.strftime("%Y%m%d.md") : "today.md")
  end

  def layouts_dir
    retter_home.join 'layouts/'
  end

  def layout_file
    layouts_dir.join 'retter.html.haml'
  end

  def profile_layout_file
    layouts_dir.join 'profile.html.haml'
  end

  def entry_layout_file
    layouts_dir.join 'entry.html.haml'
  end

  def entries_layout_file
    layouts_dir.join 'entries.html.haml'
  end

  def index_layout_file
    layouts_dir.join 'index.html.haml'
  end

  def entries_dir
    retter_home.join 'entries/'
  end

  def entry_file(date)
    entries_dir.join date.strftime('%Y%m%d.html')
  end

  def profile_file
    retter_home.join 'profile.html'
  end

  def index_file
    retter_home.join 'index.html'
  end

  def entries_file
    retter_home.join 'entries.html'
  end

  def feed_file
    retter_home.join 'entries.rss'
  end
end
