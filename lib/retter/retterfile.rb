require 'singleton'
require 'pathname'

module Retter
  class Retterfile
    autoload :Context, 'retter/retterfile/context'

    SOURCE_BRANCH = 'source'

    include Singleton

    attr_accessor :path

    def seek_load(dir = ENV['RETTER_ROOT'] || ENV['RETTER_HOME'] || Dir.pwd)
      return if dir.strip.empty?

      seek dir
      load
    end

    private

    def seek(dir)
      return if path || self.path = find_path(dir)

      attempt_checkout_source_branch dir

      if self.path = find_path(dir)
        Retter.config.source_branch = SOURCE_BRANCH
      end
    end

    def load
      return unless path

      Retter.config.root = path.dirname
      Context.instance.instance_eval path.read, path.to_s
    end

    def find_path(dir)
      dir, name = Pathname(dir).expand_path, 'Retterfile'
      candidate = dir.join(name)

      return if dir.root?

      if candidate.exist?
        return candidate
      else
        find_path(dir.dirname)
      end
    end

    def attempt_checkout_source_branch(dir)
      repo           = Repository.new(dir)
      current_branch = repo.current_branch

      if repo.branches.include?(SOURCE_BRANCH) && current_branch != SOURCE_BRANCH
        repo.checkout SOURCE_BRANCH
        at_exit do
          repo.checkout current_branch
        end
      end
    rescue Repository::RepositoryError
      # maybe dir isn't git repository
    end
  end
end
