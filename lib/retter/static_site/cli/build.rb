module Retter
  module StaticSite
    class CLI::Build < Thor::Group
      class_attribute :root_path, :source_path, :build_path, :source_branch, :publish_branch

      Retter.on_initialize do |config|
        self.root_path      = Retter.root
        self.source_path    = config.source_path
        self.build_path     = config.build_path
        self.source_branch  = config.source_branch
        self.publish_branch = config.publish_branch
      end

      include Retter::CLI::Hooks

      def build
        if wip_entry = Entry.find(&:wip?)
          wip_entry.commit!
        end

        StaticSite::Repository.checkout source_branch do
          say_status :commit, "source on #{source_branch}"
          commit_to_source_branch

          ensuring_working_path do
            say_status :build, 'assets'
            StaticSite::Builder::Assets.build

            say_status :build, 'pages'
            StaticSite::Builder::Pages.build build_path.join('public')

            say_status :commit, "files on #{publish_branch}"
            commit_to_publish_branch
          end
        end
      end

      private

      def ensuring_working_path
        FileUtils.mkdir_p build_path.join('public')
        FileUtils.cp_r    source_path.join('assets'), build_path

        yield
      ensure
        FileUtils.rm_r build_path if build_path.exist?
      end

      def commit_to_source_branch
        StaticSite::Repository.checkout source_branch do |repo|
          repo.add source_path
          repo.add '-u', source_path
          repo.commit '-m', 'Update source'
        end
      end

      def commit_to_publish_branch
        StaticSite::Repository.checkout publish_branch do |repo|
          if working_on_same_branch?
            %w(assets entries).each do |path|
              next unless File.exist?(path)

              FileUtils.rm_r path
              repo.add '-u', path
            end
          end

          repo.checkout 'master', 'Retterfile'
          FileUtils.cp_r Dir.glob(build_path.join('public/*')), Retter.root

          repo.add '-A'
          repo.commit '-m', 'Build'
        end
      end

      private

      def working_on_same_branch?
        publish_branch.to_s == source_branch.to_s
      end

      include Deprecated::CLI::Build
    end
  end
end
