module Retter
  module StaticSite
    class CLI::Migrate < Thor::Group
      include Thor::Actions

      class_attribute :root_path, :api_revision

      MIGRATION_DIRS = {
        'retters' => 'source/retters'
      }

      MIGRATION_FILES = {
        'layouts/retter.html.haml'  => 'source/templates/layouts/application.html.haml',
        'layouts/index.html.haml'   => 'source/templates/index/show.html.haml',
        'layouts/profile.html.haml' => 'source/templates/about/show.html.haml',
        'layouts/entries.html.haml' => 'source/templates/entries/index.html.haml',
        'layouts/entry.html.haml'   => 'source/templates/entries/show.html.haml',
        'layouts/article.html.haml' => 'source/templates/entries/articles/show.html.haml'
      }

      GSUB_FILES = [
        ['source/templates/layouts/application.html.haml', /\#content\s*=\s*content/m, '#content= yield'],
        ['source/templates/layouts/application.html.haml', /^!!!/, '!!! 5']
      ]

      REMOVING_FILES = %w(
        retters layouts
        entries index.html entries.html entries.rss profile.html
        config.ru
      )

      INSTALLING_FILES = %w(config.ru)

      CREATING_FILES   = {
        'source/assets' => ''
      }

      LINKS = {
        'about.html' => 'profile.html'
      }

      def migrate
        ensure_api_revision!

        Dir.chdir root_path do
          MIGRATION_DIRS.each do |src, dest|
            directory src, dest
          end

          MIGRATION_FILES.each do |src, dest|
            copy_file src, dest
          end

          GSUB_FILES.each do |args|
            gsub_file *args
          end

          REMOVING_FILES.each do |file|
            remove_file file
          end

          INSTALLING_FILES.each do |file|
            copy_file file, file
          end

          CREATING_FILES.each do |file, content|
            create_file file, content
          end

          LINKS.each do |src, dest|
            create_link dest, src
          end
        end
      end

      private

      def ensure_api_revision!
        return if api_revision == 0

        puts 'Nothing to do'
        exit
      end

      Retter.on_initialize do |config|
        self.root_path    = config.root
        self.api_revision = config.api_revision

        -> {
          def self.source_paths
            [
              root_path,
              File.expand_path('../../../../../skel', __FILE__)
            ]
          end
        }
      end
    end
  end
end
