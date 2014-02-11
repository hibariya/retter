require 'bundler/gem_tasks'
require 'fileutils'
require 'pathname'
require 'rspec/core/rake_task'
require 'tmpdir'
require 'retter'

RSpec::Core::RakeTask.new :spec

task :test_pkg => :build do
  begin
    pkg_path  = File.join(File.dirname(__FILE__), 'pkg', "retter-#{Retter::VERSION}.gem")
    build_dir = Dir.mktmpdir

    sh %(gem install #{pkg_path} -i #{build_dir} --no-document)

    Bundler.with_clean_env do
      ENV['GEM_HOME_WITH_RETTER'] = build_dir

      Rake::Task['spec'].execute
    end
  ensure
    FileUtils.remove_entry_secure build_dir
  end
end

task :default => [:spec]
task :all     => [:spec, :test_pkg]
