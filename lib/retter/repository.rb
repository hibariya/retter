# coding: utf-8

require 'grit'

module Retter
  class Repository
    include Retter::Stationery

    def initialize
      working_dir = config.retter_home.to_s
      @repo = Grit::Repo.new(working_dir)
    end

    def open
      pwd = Dir.pwd
      Dir.chdir @repo.working_dir

      yield @repo

      Dir.chdir pwd
    end
  end
end
