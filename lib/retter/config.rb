# coding: utf-8

class Retter::Config
  ATTRIBUTES =  [
    :editor,
    :title,
    :description,
    :url,
    :author,
    :retters_dir,
    :wip_file,
    :layouts_dir,
    :layout_file,
    :profile_layout_file,
    :entry_layout_file,
    :entries_layout_file,
    :index_layout_file,
    :entries_dir,
    :profile_file,
    :index_file,
    :entries_file,
    :feed_file
  ]

  ATTRIBUTES.each do |att|
    class_eval <<-EOM
      def #{att}(val = nil)
        val ? @options[:#{att}] = val : @options[:#{att}]
      end
    EOM
  end

  attr_reader :retter_home

  def initialize(env)
    @env, @options = env, {}

    detect_retter_home
    raise Retter::EnvError unless env.values_at('EDITOR', 'RETTER_HOME').all?

    @retter_home = Pathname.new(@env['RETTER_HOME'])
    load_defaults

    retterfile = retter_home.join('Retterfile')
    instance_eval retterfile.read if retterfile.exist?
  end

  def load_defaults
    editor              @env['EDITOR']
    url                 'http://example.com'
    retters_dir         retter_home.join('retters/')
    wip_file            retters_dir.join('today.md')
    layouts_dir         retter_home.join('layouts/')
    layout_file         layouts_dir.join('retter.html.haml')
    profile_layout_file layouts_dir.join('profile.html.haml')
    entry_layout_file   layouts_dir.join('entry.html.haml')
    entries_layout_file layouts_dir.join('entries.html.haml')
    index_layout_file   layouts_dir.join('index.html.haml')
    entries_dir         retter_home.join('entries/')
    profile_file        retter_home.join('profile.html')
    index_file          retter_home.join('index.html')
    entries_file        retter_home.join('entries.html')
    feed_file           retter_home.join('entries.rss')
  end

  def detect_retter_home
    # TODO こういうの上のディレクトリも見て判断するのを何か参考にして書く
    @env['RETTER_HOME'] = Dir.pwd if File.exist? 'Retterfile'
  end

  def retter_file(date)
    retters_dir.join(date ? date.strftime("%Y%m%d.md") : "today.md")
  end

  def entry_file(date)
    entries_dir.join date.strftime('%Y%m%d.html')
  end

  def self.delegatables
    ATTRIBUTES + [:retter_file, :entry_file]
  end
end
