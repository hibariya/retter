# coding: utf-8

require 'grit'

module Retter
  class Repository
    def self.open(working_dir, &block)
      new(working_dir).open(&block)
    end

    def initialize(working_dir)
      @repo = Grit::Repo.new(working_dir.to_s)
    end

    def open
      pwd = Dir.pwd
      Dir.chdir @repo.working_dir

      yield @repo

      Dir.chdir pwd
    end
  end
end
