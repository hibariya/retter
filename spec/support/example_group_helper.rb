module ExampleGroupHelper
  def command
    @command ||= Retter::Command.new
  end
end
