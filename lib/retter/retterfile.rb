require 'singleton'

module Retter
  class Retterfile
    autoload :Context, 'retter/retterfile/context'

    include Singleton

    attr_writer :path

    def load
      return false unless loadable?

      Context.instance.instance_eval path.read, path.to_s
    end

    def loadable?
      path
    end

    def path
      @path ||= find(ENV['RETTER_ROOT'] || ENV['RETTER_HOME'] || Dir.pwd)
    end

    private

    def find(dir)
      dir, name = Pathname(dir).expand_path, 'Retterfile'

      until dir.root?
        path = dir.join(name)

        return path if path.exist?

        dir = dir.dirname
      end
    end
  end
end
