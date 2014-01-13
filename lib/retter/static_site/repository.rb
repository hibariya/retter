require 'open3'

module Retter
  module StaticSite
    class Repository
      class << self
        attr_accessor :path
        attr_writer :git

        def checkout(branch, *rest, &block)
          new path do |repo|
            repo.checkout branch, *rest, &block
          end
        end

        def git
          @git || (`which git`.strip).presence
        end
      end

      Retter.on_initialize do |config|
        self.path = config.root
        self.git  = config.git
      end

      attr_reader :path, :git

      def initialize(path, git = Repository.git)
        @path, @git = path, git

        Dir.chdir path do
          yield self
        end if block_given?
      end

      def command(command, *args)
        unless git
          warn %(git command not found. Skipping #{command})
          return
        end

        [git, command.to_s, *args.map(&:to_s)]
      end

      %w(init add reset).each do |subcommand|
        define_method subcommand do |*args|
          run command(subcommand, *args)
        end
      end

      def commit(*args)
        run command('commit', *args), false
      end

      def current_branch
        capture(command('name-rev', '--name-only', 'HEAD'))
      end

      def branches
        capture(command('branch')).split($/).map {|br|
          br.sub(/\s*\*\s*/, '').strip
        }
      end

      def checkout(*args, &block)
        return do_checkout *args unless block

        checkout_temporary *args, &block
      end

      private

      def checkout_temporary(*args)
        _branch = current_branch

        do_checkout *args
        yield self
      ensure
        do_checkout _branch rescue warn("WARNING: can't checkout #{_branch}")
      end

      def do_checkout(name, *rest)
        return if current_branch == name

        run command('checkout', name, *rest)
      end

      def capture(cmd, raise_on_fail = true)
        value, status = Open3.capture2e(*cmd)

        if status.success?
          value.strip
        else
          if raise_on_fail
            warn value
            raise "command failed: #{Array(cmd).join(' ')}"
          end

          false
        end
      end

      alias run capture
    end
  end
end
