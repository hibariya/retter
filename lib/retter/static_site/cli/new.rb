require 'fileutils'
require 'pathname'

module Retter
  module StaticSite
    class CLI::New < Retter::CLI::New
      ROOT_FILES    = %w(.gitignore config.ru)
      SOURCE_FILES  = %w(
        retters/.gitkeep
        retters/today.md
        assets/images/orange/bg_body.jpg
        assets/images/orange/bg_entry.jpg
        assets/images/orange/bg_header.png
        assets/images/orange/ic_li01.gif
        assets/stylesheets/application.css.scss
        assets/stylesheets/base.css.scss
        assets/stylesheets/highlight.css.scss
        assets/stylesheets/orange.css.scss
        assets/stylesheets/retter.css.scss
        templates/about/show.html.haml
        templates/entries/articles/show.html.haml
        templates/entries/index.html.haml
        templates/entries/show.html.haml
        templates/index/show.html.haml
        templates/layouts/application.html.haml
      )

      def self.source_paths
        super << File.expand_path('../../app', __FILE__)
      end

      def install
        Repository.new name do |repo|
          repo.init

          ROOT_FILES.each do |file|
            copy_file file, %(#{name}/#{file})
          end

          SOURCE_FILES.each do |file|
            copy_file file, %(#{name}/source/#{file})
          end

          repo.add '-A'
          repo.commit '-m', 'Initial'
        end
      end
    end
  end
end
