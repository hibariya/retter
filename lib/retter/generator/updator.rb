# coding: utf-8

class Retter::Generator::Updator < Retter::Generator::Base
  def complete_message
    say 'Website has been updated!', :green
  end
end
