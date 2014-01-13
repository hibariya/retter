require 'open3'

module Retter::ExampleHelper
  class Result < Struct.new(:stdout, :stderr, :status); end

  RETTER_COMMAND = ['bundle', 'exec', GEM_DIR.join('bin/retter').to_path]

  module_function

  def invoke_retter(*task_with_options)
    Result.new(
      *Open3.capture3(*RETTER_COMMAND, *task_with_options.map(&:to_s))
    )
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
end
