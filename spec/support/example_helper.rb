require 'open3'
require 'bundler'

module Retter::ExampleHelper
  class Result < Struct.new(:stdout, :stderr, :status); end

  module_function

  def invoke_retter(*args)
    options = args.extract_options!
    editor  = ENV['EDITOR']

    Bundler.with_clean_env {
      ENV['EDITOR'] = editor
      remove_retter_env

      Result.new(
        *Open3.capture3(*retter_command(args.map(&:to_s), retter_root: options[:retter_root] || Dir.pwd))
      )
    }
  end

  def capture_command(*cmd)
    output, status = Open3.capture2e(*cmd)

    output
  end

  alias run_command capture_command

  def retter_command(task_with_options, retter_root: Dir.pwd)
    if gem_home = ENV['GEM_HOME_WITH_RETTER']
      [{'GEM_HOME' => gem_home}, 'retter', *task_with_options]
    else
      [{'RETTER_ROOT' => retter_root}, 'bundle', 'exec', RETTER_GEM_DIR.join('bin/retter').to_path, *task_with_options, {chdir: RETTER_GEM_DIR.to_path}]
    end
  end

  def remove_retter_env
    %w(RETTER_HOME RETTER_ROOT).each do |name|
      ENV.delete name
    end
  end
end
