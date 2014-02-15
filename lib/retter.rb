require 'active_support/concern'
require 'active_support/core_ext'
require 'active_support/ordered_options'
require 'retter/version'

module Retter
  autoload :CLI,          'retter/cli'
  autoload :Deprecated,   'retter/deprecated'
  autoload :Entry,        'retter/entry'
  autoload :Initializing, 'retter/initializing'
  autoload :Repository,   'retter/repository'
  autoload :Retterfile,   'retter/retterfile'
  autoload :StaticSite,   'retter/static_site'

  include Initializing
  include Deprecated::Retter
  include Deprecated::Site

  API_REVISION = 1

  class << self
    def config
      @config ||= ActiveSupport::OrderedOptions.new
    end

    def root; config.root end

    def retterfile
      Retterfile.instance
    end

    def initialize!
      @config = nil

      load_defaults
      retterfile.seek_load

      install_site_module
      warn_missing_api_revision

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
      config.editor         = env['EDITOR']
      config.shell          = env['SHELL']
      config.url            = 'http://example.com'
      config.site_type      = Retter::StaticSite
    end

    def warn_missing_api_revision
      return if config.api_revision == API_REVISION
      return unless root

      warn <<-MESSAGE.strip_heredoc
        *** WARNING ***
        Reading site (#{root.basename}) isn't compatible with current retter version (#{VERSION}).
        Please run `retter migrate` or `gem uninstall retter -v #{VERSION}`.
      MESSAGE
    end
  end
end
