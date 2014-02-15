module Retter
  class CLI::New < Thor::Group
    argument :name, type: :string, required: true, desc: 'Site name'

    def new
      # TODO: get site_type and load modules
    end
  end
end
