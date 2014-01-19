require 'thor'

module Retter
  module CLI
    autoload :Edit,    'retter/cli/edit'
    autoload :Hooks,   'retter/cli/hooks'
    autoload :List,    'retter/cli/list'
    autoload :New,     'retter/cli/new'
    autoload :Preview, 'retter/cli/preview'
    autoload :Publish, 'retter/cli/publish'

    class Command < Thor
      include Thor::Actions
      include Deprecated::CLI::Command

      register Edit,    'edit',    'edit [KEYOWRD]', 'Open an entry with $EDITOR'
      register List,    'list',    'list',           'List all entries'
      register New,     'new',     'new NAME',       'Create a new site'
      register Preview, 'preview', 'preview',        'Preview on browser'
      register Publish, 'publish', 'publish',        'Run publish proc on $RETTER_ROOT'

      default_task :edit

      map '--version' => :version, '-v' => :version

      desc :version, 'Show version'
      def version
        puts VERSION
      end

      no_tasks do
        def invoke(klass_or_name, *)
          super

          klass_or_name.call_hooks :after if klass_or_name.respond_to?(:call_hooks)
        end
      end
    end

    class << self
      def start(*args)
        Command.start *args
      end
    end
  end
end
