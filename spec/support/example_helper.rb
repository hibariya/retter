require 'open3'
require 'bundler'

module Retter::ExampleHelper
  class Result < Struct.new(:stdout, :stderr, :status); end

  module_function

  def invoke_retter(*task_with_options)
    editor = ENV['EDITOR']

    Bundler.with_clean_env {
      ENV['EDITOR'] = editor
      remove_retter_env

      Result.new(
        *Open3.capture3(*retter_command, *task_with_options.map(&:to_s))
      )
    }
  end

  def capture_command(*cmd)
    output, status = Open3.capture2e(*cmd)

    output
  end

  alias run_command capture_command

  def clean_test_tmp_dir
    FileUtils.rm_r    TEST_TMP_DIR if TEST_TMP_DIR.exist?
    FileUtils.mkdir_p TEST_TMP_DIR
  end

  def retter_command
    if gem_home = ENV['GEM_HOME_WITH_RETTER']
      [{'GEM_HOME' => gem_home}, 'retter']
    else
      ['bundle', 'exec', GEM_DIR.join('bin/retter').to_path]
    end
  end

  def remove_retter_env
    %w(RETTER_HOME RETTER_ROOT).each do |name|
      ENV.delete name
    end
  end
end
