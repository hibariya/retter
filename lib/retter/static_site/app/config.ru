# This file is used by Rack-based servers to start the application.

require_relative 'application'

Retter::StaticSite::App::Application.initialize!

run Rails.application
