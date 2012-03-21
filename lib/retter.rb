# coding: utf-8

here = File.dirname(__FILE__)
$LOAD_PATH.unshift here unless $LOAD_PATH.include?(here)

module Retter
  class RetterError < RuntimeError; end

  module Stationery
    [:config, :entries].each do |meth|
      define_method meth do
        Retter.send meth
      end
    end
  end

  class << self
    attr_reader :config

    def load(env)
      @config = Config.new(env)
    end

    def reset!
      @entries = nil
    end

    def entries
      @entries ||= Entries.new
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

require 'date'
require 'time'
require 'pathname'
