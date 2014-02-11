require_relative 'helpers'

module Retter
  module StaticSite
    module App
      class ApplicationController < ActionController::Base
        layout 'application'

        helper ApplicationHelper, CompatibilityHelper

        before_filter :reload_entries, :prepend_view_paths

        private

        def entries
          @entries ||= Retter::Entry.order_by(:date).reverse
        end
        helper_method :entries

        def articles
          @articles ||= entries.flat_map(&:articles)
        end
        helper_method :articles

        def title
          App.config.title
        end
        helper_method :title

        def reload_entries
          @entries, @articles = nil

          Retter::Entry.load if Rails.env.development?
        end

        def prepend_view_paths
          App::Application.config.real_root.tap do |real_root|
            prepend_view_path real_root.join('templates').to_path
          end

          prepend_view_path App.config.source_path.join('templates').to_path
        end
      end

      class IndexController < ApplicationController
        def show
          render 'index/show'
        end
      end

      class AboutController < ApplicationController
        def show
          render 'about/show'
        end
      end

      class EntriesController < ApplicationController
        attr_reader :entry
        helper_method :entry

        def index
          respond_to do |f|
            f.html { render 'entries/index' }
            f.rss  { render 'entries/index', layout: false }
          end
        end

        def show
          date   = Date.parse(params[:id])
          @entry = Retter::Entry.find(date)

          render 'entries/show'
        end

        def last_modified
          entry = Retter::Entry.order_by(:modified_at).last

          redirect_to retter_entry_path(entry, format: 'html')
        end

        private

        def title
          return super unless entry

          %(#{entry.date} - #{super})
        end
      end

      module Entries
        class ArticlesController < ApplicationController
          attr_reader   :entry, :article
          helper_method :entry, :article

          def show
            date = Date.parse(params[:entry_id])

            @entry   = Retter::Entry.find(date)
            @article = @entry.articles.find {|a| a.relative_code == params[:id] }

            render 'entries/articles/show'
          end

          private

          def title
            %(#{article.title} - #{super})
          end
        end
      end
    end
  end
end
