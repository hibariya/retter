require 'action_controller/railtie'
require 'sprockets/railtie'

require 'jquery-rails'
require 'uri'
require 'sass'
require 'haml'

require 'retter'

module Retter
  module StaticSite
    module App
      class Application < Rails::Application
        config.real_root = Pathname(__FILE__).dirname

        url = URI(App.config.url)
        config.action_controller.default_url_options = {host: url.host, port: url.port, protocol: url.scheme}

        config.logger = Logger.new(StringIO.new)

        # probably not in use
        config.secret_key_base = '7da522cea316445dca8ae7f3f2941cb620c9fd36d1315b871df2bf79b567018fa0dbe7653192d290b1347500ee6f78cc1e4f1c788c6d6db53eb39c4c40cf6a8e'
        config.session_store :cookie_store, key: '_retter_preview_session'

        config.active_support.deprecation        = :notify

        config.assets.precompile  += %w(*.*)
        config.assets.digest       = true
        config.serve_static_assets = true
        %w(stylesheets javascripts images).each do|type|
          config.assets.paths << App.config.source_path.join('assets', type).to_path
          config.assets.paths << App.config.root.join(type).to_path
          config.assets.paths << config.real_root.join('assets', type).to_path
        end

        if Rails.env.development?
          require 'rack-livereload'

          config.middleware.use Rack::LiveReload
          config.root                              = App.config.root
          config.cache_classes                     = false
          config.eager_load                        = false
          config.consider_all_requests_local       = true
          config.action_controller.perform_caching = false
          config.assets.compile                    = true
        else
          config.root                              = App.config.build_path
          config.cache_classes                     = true
          config.eager_load                        = true
          config.consider_all_requests_local       = false
          config.action_controller.perform_caching = true
          config.assets.js_compressor              = :uglifier
          config.assets.compile                    = false
          config.assets.version                    = '1.0'
          config.log_level                         = :info
          config.i18n.fallbacks                    = true
        end

        config.after_initialize do |app|
          app.routes.draw do
            scope module: 'retter/static_site/app' do
              root to: 'index#show'

              scope do # compat for <0.2.5
                get '/profile.html',               to: 'about#show',            as: :profile
                get '/entries/:id.html',           to: 'entries#show',          as: :entry
                get '/entries/:entry_id/:id.html', to: 'entries/articles#show', as: :entry_article

                get '/:assets/:fname' => redirect('/assets/%{fname}'), constraints: {fname: /.+/, assets: /(stylesheets|images|javascripts)/}
              end

              scope as: :retter do
                get :index, to: 'index#show'
                get :about, to: 'about#show'

                resources :entries, only: %w(index show) do
                  get :last_modified, on: :collection

                  resources :articles, only: %w(show), controller: 'entries/articles', path: ''
                end
              end
            end
          end

          require_relative 'controllers'
          require_relative 'helpers'
        end
      end
    end
  end
end

Haml::Template.options[:format] = :xhtml
