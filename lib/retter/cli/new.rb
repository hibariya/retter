module Retter
  class CLI::New < Thor::Group
    argument :name, type: :string, required: true, desc: 'Site name'

    def new
      # nothing to do
    end
  end
end
