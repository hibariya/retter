require 'singleton'
require 'pathname'

module Retter
  class Retterfile
    autoload :Context, 'retter/retterfile/context'

    include Singleton

    attr_accessor :path

    def find_load(dir = ENV['RETTER_ROOT'] || ENV['RETTER_HOME'] || Dir.pwd)
      find dir
      load
    end

    private

    # FIXME: It has many side effects
    def find(dir)
      return if @path || @path = find_path(dir)

      # FIXME: It's not main process...
      repo           = Repository.new(dir)
      source_branch  = 'source'
      current_branch = repo.current_branch
      branches       = repo.branches

      if branches.include?(source_branch) && current_branch != source_branch
        repo.checkout source_branch
        at_exit do
          repo.checkout current_branch
        end

        if @path = find_path(dir)
          Retter.config.source_branch = source_branch
        end
      end
    end

    def load
      return unless @path

      Context.instance.instance_eval path.read, path.to_s
    end

    def find_path(dir)
      dir, name = Pathname(dir).expand_path, 'Retterfile'

      until dir.root?
        path = dir.join(name)

        return path if path.exist?

        dir = dir.dirname
      end
    end
  end
end
