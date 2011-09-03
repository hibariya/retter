# coding: utf-8

require 'thor/group'
require 'grit'
require 'bundler'
require 'bundler/cli'

class Newretter < Thor::Group
  FILES = %w(
    .gitignore
    Gemfile
    Retterfile
    config.ru
    layouts/entries.html.haml
    layouts/entry.html.haml
    layouts/profile.html.haml
    layouts/index.html.haml
    layouts/retter.html.haml
    images/.gitkeep
    index.html
    entries/.gitkeep
    javascripts/.gitkeep
    stylesheets/application.css
    retters/.gitkeep
  )

  include Thor::Actions

  argument :name

  def self.source_root
    File.dirname(__FILE__)
  end

  def create_files
    FILES.each do |file|
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
    say <<-EOM, :green
-- Thanks for flying Retter :-> --
You have to set $RETTER_HOME variable to use #{name}.
example:
  export RETTER_HOME=#{Dir.pwd}/#{name}
    EOM
  end
end
