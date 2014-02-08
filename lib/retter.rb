require 'active_support/concern'
require 'active_support/core_ext'
require 'active_support/ordered_options'
require 'retter/version'

module Retter
  autoload :CLI,          'retter/cli'
  autoload :Config,       'retter/config'
  autoload :Deprecated,   'retter/deprecated'
  autoload :Entry,        'retter/entry'
  autoload :Initializing, 'retter/initializing'
  autoload :Retterfile,   'retter/retterfile'
  autoload :StaticSite,   'retter/static_site'

  extend Initializing

  include Deprecated::Retter
  include Deprecated::Site

  API_REVISION = 1

  class << self
    def config
      @config ||= ActiveSupport::OrderedOptions.new.tap {|config|
        config.extend Config::ConfigMethods
      }
    end

    def root; config.root end

    def retterfile
      Retterfile.instance
    end

    def initialize!
      @config = nil

      load_defaults
      retterfile.load
      install_site_module

      process_initialize
    end

    private

    def env
      ENV
    end

    def install_site_module
      return unless mod = config.site_type

      mod.install
    end

    def load_defaults
      config.api_revision ||= 0
      config.callbacks      = ActiveSupport::OrderedOptions.new

      config.editor    = env['EDITOR']
      config.shell     = env['SHELL']
      config.url       = 'http://example.com'
      config.site_type = Retter::StaticSite

      if root = retterfile.path.try(:dirname)
        config.root = root
      end
    end
  end
end
