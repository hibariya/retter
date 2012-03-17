# coding: utf-8

here = File.dirname(__FILE__)
$LOAD_PATH.unshift here unless $LOAD_PATH.include?(here)

module Retter
  class RetterError < RuntimeError; end

  module Stationery
    [:config, :entries, :preprint, :pages, :repository].each do |meth|
      define_method meth do
        Retter.send meth
      end
    end
  end

  class << self
    def load_config(env)
      @config = Config.new(env)
    end

    def config
      @config
    end

    def reset_entries!
      @entries = nil
    end

    singletons = [:entries, :preprint, :pages, :repository]
    singletons.each do |sym|
      define_method sym do
        eval "@#{sym} ||= #{sym.capitalize}.new"
      end
    end
  end

  autoload :Generator,  'retter/generator'

  autoload :VERSION,    'retter/version'
  autoload :Config,     'retter/config'
  autoload :Renderers,  'retter/renderers'
  autoload :Entry,      'retter/entry'
  autoload :Entries,    'retter/entries'
  autoload :Page,       'retter/page'
  autoload :Pages,      'retter/pages'
  autoload :Preprint,   'retter/preprint'
  autoload :Repository, 'retter/repository'
  autoload :Command,    'retter/command'
end

require 'date'
require 'time'
require 'pathname'
