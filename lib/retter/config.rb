# coding: utf-8

require 'active_support/cache'
require 'forwardable'

module Retter
  class EnvError < RetterError; end

  class Config
    extend Forwardable

    def_delegators Retter::Entries,        :renderer, :retters_dir, :wip_file
    def_delegators Retter::Pages,          :layouts_dir, :layout_file, :entries_dir
    def_delegators Retter::Pages::Profile, :profile_layout_file, :profile_file
    def_delegators Retter::Pages::Entry,   :entry_layout_file
    def_delegators Retter::Pages::Article, :article_layout_file
    def_delegators Retter::Pages::Archive, :entries_file, :entries_layout_file
    def_delegators Retter::Pages::Index,   :index_file, :index_layout_file
    def_delegators Retter::Pages::Feed,    :feed_file

    ATTRIBUTES = [
      :editor,
      :shell,
      :cache,
      :title,
      :description,
      :url,
      :author
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
      cache               ActiveSupport::Cache::FileStore.new(retter_home.join('tmp/cache').to_path)
      url                 'http://example.com'

      renderer            Retter::Renderers::CodeRayRenderer
      retters_dir         retter_home.join('retters/')
      wip_file            retters_dir.join('today.md')

      layouts_dir         retter_home.join('layouts/')
      layout_file         layouts_dir.join('retter.html.haml')

      profile_layout_file layouts_dir.join('profile.html.haml')
      profile_file        retter_home.join('profile.html')

      entries_dir         retter_home.join('entries/')
      entries_layout_file layouts_dir.join('entries.html.haml')
      entries_file        retter_home.join('entries.html')
      entry_layout_file   layouts_dir.join('entry.html.haml')
      article_layout_file layouts_dir.join('article.html.haml')

      index_layout_file   layouts_dir.join('index.html.haml')
      index_file          retter_home.join('index.html')

      feed_file           retter_home.join('entries.rss')
    end

    def load_retterfile_if_exists
      retterfile = retter_home.join('Retterfile')
      instance_eval retterfile.read, retterfile.to_path if retterfile.exist?
    end

    def detect_retter_home
      # TODO こういうの上のディレクトリも見て判断するのを何か参考にして書く
      @env['RETTER_HOME'] = Dir.pwd if File.exist? 'Retterfile'
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
