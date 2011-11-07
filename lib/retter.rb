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

  autoload :Generator, 'retter/generator'
end

require 'date'
require 'time'
require 'builder'
require 'pathname'
require 'thor'
require 'redcarpet'
require 'coderay'
require 'nokogiri'
require 'launchy'
require 'haml'
require 'uri'
require 'forwardable'
require 'grit'

require 'retter/version'
require 'retter/config'
require 'retter/renderer'
require 'retter/entry'
require 'retter/entries'
require 'retter/page'
require 'retter/pages'
require 'retter/preprint'
require 'retter/repository'
require 'retter/command'
