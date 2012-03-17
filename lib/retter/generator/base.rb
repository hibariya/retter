# coding: utf-8

require 'thor/group'
require 'grit'
require 'bundler'
require 'bundler/cli'
require 'retter'

class Retter::Generator::Base < Thor::Group
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
    tmp/cache/.gitkeep
    javascripts/.gitkeep
    stylesheets/base.css
    stylesheets/retter.css
    stylesheets/pygments.css

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
end
