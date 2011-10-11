# coding: utf-8

require 'thor/group'
require 'grit'
require 'bundler'
require 'bundler/cli'
require 'retter'

class Newretter < Thor::Group
  TEMPLATES = %w(
    Retterfile
    Gemfile
    config.ru
    index.html
    layouts/entries.html.haml
    layouts/entry.html.haml
    layouts/article.html.haml
    layouts/profile.html.haml
    layouts/index.html.haml
    layouts/retter.html.haml
  )

  FILES = %w(
    .gitignore
    retters/.gitkeep
    images/.gitkeep
    entries/.gitkeep
    javascripts/.gitkeep
    stylesheets/base.css
    stylesheets/retter.css

    stylesheets/orange.css
    images/orange/bg_body.jpg
    images/orange/bg_entry.jpg
    images/orange/bg_header.png
  )

  include Thor::Actions

  argument :name

  def self.source_root
    File.dirname(__FILE__)
  end

  def create_files
    FILES.each do |file|
      copy_file("skel/#{file}", "#{name}/#{file}")
    end

    TEMPLATES.each do |file|
      template("skel/#{file}", "#{name}/#{file}")
    end
  end

  def bundle_install
    pwd = Dir.pwd
    FileUtils.cd name

    Bundler::CLI.new.install

    FileUtils.cd pwd
  end

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
