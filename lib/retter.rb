# coding: utf-8

here = File.dirname(__FILE__)
$LOAD_PATH.unshift here unless $LOAD_PATH.include?(here)

require 'date'
require 'time'
require 'pathname'
require 'active_support/time_with_zone' # XXX: workaround for uninitialized constant ActiveSupport::TimeWithZone (NameError)

module Retter
  autoload :Generator,    'retter/generator'
  autoload :VERSION,      'retter/version'
  autoload :Configurable, 'retter/configurable'
  autoload :Config,       'retter/config'
  autoload :Markdown,     'retter/markdown'
  autoload :Entry,        'retter/entry'
  autoload :Entries,      'retter/entries'
  autoload :Page,         'retter/page'
  autoload :Binder,       'retter/binder'
  autoload :Preprint,     'retter/preprint'
  autoload :Repository,   'retter/repository'
  autoload :Command,      'retter/command'

  class RetterError < RuntimeError; end

  module Site
    extend self
    extend Configurable

    configurable :home, :title, :description, :url, :author

    def load(env)
      @@config = Config.new(env)
    end

    def reset!
      @@entries = nil
    end

    def entries
      @@entries ||= Entries.new
    end

    def config
      @@config
    end
  end

  class << self
    def const_missing(name)
      case name.intern
      when :Renderers
        warn %(Retter::Renderers is OBSOLETE, Use Retter::Markdown.)

        Markdown
      else
        super
      end
    end
  end
end
