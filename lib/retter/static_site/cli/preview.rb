require 'guard'
require 'launchy'
require 'net/http'
require 'rack'

module Retter
  module StaticSite
    class CLI::Preview < Retter::CLI::Preview
      class_attribute :source_path, :source_branch

      Retter.on_initialize do |config|
        self.source_path   = config.source_path
        self.source_branch = config.source_branch
      end

      DEFAULT_ENTRY_POINT = '/entries/last_modified'

      argument :entry_point, type: :string, required: false, default: DEFAULT_ENTRY_POINT, desc: 'The entry point to site'
      class_option :port, type: :numeric, default: 9292
      class_option :livereload, type: :boolean, default: true

      def preview
        StaticSite::Repository.checkout source_branch do
          Retter.initialize!

          invoke_browser_after_startup
          invoke_livereload if options.livereload

          config = File.join(File.dirname(__FILE__), '../app/config.ru')

          Rack::Server.new(config: config, Port: options.port).start
        end
      end

      private

      def invoke_browser_after_startup(limit = 30)
        Thread.fork do
          begin
            Net::HTTP.start 'localhost', options.port do
              Launchy.open %(http://localhost:#{options.port}#{entry_point})
            end
          rescue Launchy::Error
            Launchy.open %(http://localhost:#{options.port}#{DEFAULT_ENTRY_POINT})
          rescue
            sleep 0.25

            limit -= 1
            retry if limit > 0
          end
        end
      end

      def invoke_livereload
        Thread.fork do
          Guard::UI.logger.level = :error
          Guard.start watchdir: source_path.dirname.to_s, no_interactions: true, guardfile_contents: <<-EOS
            guard 'livereload' do
              watch %r{#{source_path.basename}/.+}
            end
          EOS
        end
      end
    end
  end
end
