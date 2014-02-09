require 'fileutils'
require 'pathname'
require 'rails/console/app'
require 'rake'
require 'retter/static_site/monkey/sprockets_task'

module Retter
  module StaticSite
    module Builder
      class Base
        class << self
          def build(*args)
            builder = new(*args)

            builder.build_wait
          end
        end

        def initialize_application
          ENV['RACK_ENV'] = ENV['RAILS_ENV'] = 'production'

          Retter::StaticSite::App::Application.initialize!
        end

        def build_wait
          pid       = fork { build }
          _, status = Process.waitpid2(pid)

          at_exit do
            Process.kill :TERM, pid rescue nil # avoid orphan
          end

          status.success?
        end

        def build
          raise NotImplementedError
        end
      end

      class Assets < Base
        def build
          initialize_application

          Retter::StaticSite::App::Application.load_tasks

          Rake::Task['assets:precompile'].invoke
        end
      end

      class Pages < Base
        attr_reader :dest_path

        def initialize(dest_path)
          @dest_path = dest_path
        end

        def build
          initialize_application
          extend Rails::ConsoleMethods

          urls.each do |url|
            write fetch(url), dest_path.join(url[1..-1])
          end
        end

        private

        def urls
          html_page = {format: 'html'}

          static_pages = [
            app.retter_index_path(html_page),
            app.retter_about_path(html_page),
            app.retter_entries_path(html_page),
            app.retter_entries_path(format: 'rss')
          ]

          entry_pages   = Retter::Entry.all.map {|entry| app.retter_entry_path(entry, html_page) }
          article_pages = Retter::Entry::Article.all.map {|article| app.retter_entry_article_path(article.entry, article, html_page) }

          static_pages + entry_pages + article_pages
        end

        def fetch(url, retry_limit = 10)
          app.get url
          response = app.response

          if response.redirect?
            raise 'Redirect loop is too deep' if retry_limit <= 0

            return fetch(response.redirect_url, retry_limit.pred) 
          end

          response.body
        end

        def write(body, dest)
          FileUtils.mkdir_p dest.dirname

          File.binwrite dest, body
        end
      end
    end
  end
end
