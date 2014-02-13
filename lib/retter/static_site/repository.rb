require 'open3'

# Move to Retter::Repository
module Retter
  module StaticSite
    class Repository
      class << self
        attr_accessor :path
        attr_writer :git

        def checkout(branch, *rest, &block)
          new do |repo|
            repo.checkout branch, *rest, &block
          end
        end

        def git
          @git ||= `which git`.strip.presence
        end
      end

      attr_reader :path, :git

      def initialize(path = Repository.path, git = Repository.git)
        @path, @git = Pathname(path).expand_path, git

        Dir.chdir path do
          yield self
        end if block_given?
      end

      %w(init add reset rm).each do |subcommand|
        define_method subcommand do |*args|
          run command(subcommand, *args)
        end
      end

      def commit(*args)
        run command('commit', *args), false
      end

      def checkout(*args, &block)
        return do_checkout *args unless block

        checkout_temporary *args, &block
      end

      def current_branch
        extract_branch_name(branch_list.grep(/\*/).first)
      end

      def branches
        branch_list.map {|str| extract_branch_name(str) }
      end

      private

      def branch_list
        capture(command('branch')).split("\n")
      end

      def extract_branch_name(str)
        str.sub(/\*/, '').strip
      end

      def checkout_temporary(*args)
        _branch = current_branch

        do_checkout *args
        yield self
      ensure
        do_checkout _branch
      end

      def do_checkout(name, *rest)
        return if name == current_branch

        run command('checkout', name, *rest)
      rescue
        warn "WARNING: can't checkout #{_branch}"
      end

      def command(command, *args)
        raise %(git command not found. Command failed: `#{command}'.) unless git

        [git, command.to_s, *args.map(&:to_s)]
      end

      def capture(cmd, raise_on_fail = true)
        value, status = Dir.chdir(path) {
          Open3.capture2e(*cmd)
        }

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

      Retter.on_initialize do |config|
        self.path = config.root
        self.git  = config.git
      end
    end
  end
end
