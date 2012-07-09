# coding: utf-8

here = File.dirname(__FILE__)
$LOAD_PATH.unshift here unless $LOAD_PATH.include?(here)

require 'date'
require 'time'
require 'pathname'

module Retter
  class RetterError < RuntimeError; end

  module Site
    extend self

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

  autoload :Generator,    'retter/generator'

  autoload :VERSION,      'retter/version'
  autoload :Configurable, 'retter/configurable'
  autoload :Config,       'retter/config'
  autoload :Renderers,    'retter/renderers'
  autoload :Entry,        'retter/entry'
  autoload :Entries,      'retter/entries'
  autoload :Page,         'retter/page'
  autoload :Pages,        'retter/pages'
  autoload :Preprint,     'retter/preprint'
  autoload :Repository,   'retter/repository'
  autoload :Command,      'retter/command'
end
