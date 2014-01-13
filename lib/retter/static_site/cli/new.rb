require 'fileutils'
require 'pathname'

module Retter
  module StaticSite
    class CLI::New < Retter::CLI::New
      include Thor::Actions

      MINIMUM_FILES = %w(Retterfile)
      PUBLISH_FILES = %w(.gitignore config.ru)
      ROOT_FILES    = %w(.gitignore)
      SOURCE_FILES  = %w(
        retters/.gitkeep
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
        [
          File.expand_path('../../../../../skel', __FILE__),
          File.expand_path('../../app', __FILE__)
        ]
      end

      def install_minimum
        say_status :prepare, 'minimum files'

        FileUtils.mkdir_p name

        MINIMUM_FILES.each do |template|
          template template, %(#{name}/#{template})
        end
      end

      def initialize_retter
        Retter.retterfile.path = Pathname(File.expand_path(name)).join('Retterfile')
        Retter.initialize!
      end

      def prepare_source_repository
        say_status :prepare, 'source repository (master)'

        StaticSite::Repository.new name do |repo|
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

      def prepare_publish_branch
        say_status :prepare, 'publish repository (gh-pages)'

        StaticSite::Repository.checkout 'master' do |repo|
          repo.checkout '--orphan', 'gh-pages' do # TODO: fallback to normal branch
            repo.rm '-rf', '.'                    # repo.reset '--hard' fails git-1.7.9.5 or earlier

            PUBLISH_FILES.each do |file|
              copy_file file, %(#{name}/#{file})
            end

            repo.add *PUBLISH_FILES
            repo.commit '-m', 'Initial'
          end
        end
      end
    end
  end
end
