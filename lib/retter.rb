require 'active_support/concern'
require 'active_support/core_ext'
require 'active_support/ordered_options'
require 'retter/version'

module Retter
  autoload :CLI,        'retter/cli'
  autoload :Config,     'retter/config'
  autoload :Deprecated, 'retter/deprecated'
  autoload :Entry,      'retter/entry'
  autoload :Retterfile, 'retter/retterfile'
  autoload :StaticSite, 'retter/static_site'

  include Deprecated::Retter
  include Deprecated::Site

  API_REVISION = 1

  class << self
    # Usage:
    #  Retter.on_initialize do |config|
    #    initialize process
    #    -> { after initialize process (optional) }
    #  end
    def on_initialize(&block)
      call_initializers(block).tap do |after_initialize_hooks|
        after_initialize_hooks.each &:call
      end if initialized?

      initializers << block
    end

    def initialize!
      @config = nil

      load_defaults
      retterfile.load

      install_site_module

      call_initializers.tap do |after_initialize_hooks|
        @initialized = true

        after_initialize_hooks.each &:call
      end
    end

    def initialized?; @initialized end

    def root; config.root end

    def config
      @config ||= ActiveSupport::OrderedOptions.new.tap {|config|
        config.extend Config::ConfigMethods
      }
    end

    def env
      ENV
    end

    def retterfile
      Retterfile.instance
    end

    private

    def install_site_module
      return unless mod = config.site_type

      mod.install
    end

    def initializers
      @initializers ||= []
    end

    def call_initializers(procs = initializers)
      Array(procs).each.with_object([]) {|initialize_proc, after_procs|
        returned = initialize_proc.call(config)

        after_procs << returned if returned.respond_to?(:call)
      }
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
