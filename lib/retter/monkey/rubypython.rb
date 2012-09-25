require 'rubypython'

if RubyPython::VERSION <= '0.5.3'
  # Monkey patching for https://github.com/tmm1/pygments.rb/issues/10
  class RubyPython::PythonExec
    # Run a Python command-line command.
    def run_command(command)
      %x("#{@python} -c #{command}").chomp if @python
    end
  end
end
