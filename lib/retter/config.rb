# coding: utf-8

module Retter
  class EnvError < RetterError; end

  class Config
    ATTRIBUTES = [
      :editor,
      :shell,
      :renderer,
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
      :article_layout_file,
      :entries_layout_file,
      :index_layout_file,
      :entries_dir,
      :profile_file,
      :index_file,
      :entries_file,
      :feed_file
    ] + [ # extras
      :disqus_shortname
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
      @after_callbacks = {}

      detect_retter_home
      unless env.values_at('EDITOR', 'RETTER_HOME').all?
        raise Retter::EnvError, 'Set $RETTER_HOME and $EDITOR, first.'
      end

      @retter_home = Pathname.new(@env['RETTER_HOME'])
      load_defaults
      load_retterfile_if_exists
      rescue Retter::EnvError
        $stderr.puts 'Set $RETTER_HOME and $EDITOR, first.'
        say Retter::Command.usage, :green
        exit 1
    end

    def load_defaults
      editor              @env['EDITOR']
      shell               @env['SHELL']
      renderer            Renderers::CodeRayRenderer
      url                 'http://example.com'
      retters_dir         retter_home.join('retters/')
      wip_file            retters_dir.join('today.md')
      layouts_dir         retter_home.join('layouts/')
      layout_file         layouts_dir.join('retter.html.haml')
      profile_layout_file layouts_dir.join('profile.html.haml')
      entry_layout_file   layouts_dir.join('entry.html.haml')
      article_layout_file layouts_dir.join('article.html.haml')
      entries_layout_file layouts_dir.join('entries.html.haml')
      index_layout_file   layouts_dir.join('index.html.haml')
      entries_dir         retter_home.join('entries/')
      profile_file        retter_home.join('profile.html')
      index_file          retter_home.join('index.html')
      entries_file        retter_home.join('entries.html')
      feed_file           retter_home.join('entries.rss')
    end

    def load_retterfile_if_exists
      retterfile = retter_home.join('Retterfile')
      instance_eval retterfile.read, retterfile.to_s if retterfile.exist?
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

    def entry_dir(date)
      entries_dir.join date.strftime('%Y%m%d')
    end

    def self.delegatables
      ATTRIBUTES + [:retter_file, :entry_file, :entry_dir]
    end

    def after(name, sym = nil, &block)
      if callback = sym || block
        @after_callbacks[name] = callback
      else
        @after_callbacks[name]
      end
    end
  end
end
