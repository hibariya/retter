module Retter
  class CLI::New < Thor::Group
    include Thor::Actions

    argument :name, type: :string, required: true, desc: 'Site name'
    class_option :minimum, default: false, type: :boolean, desc: 'Install minimum files only'

    def self.source_paths
      [File.expand_path('../../../../skel', __FILE__)]
    end

    def instal_minimum
      FileUtils.mkdir_p name

      template 'Retterfile', %(#{name}/Retterfile)

      exit if options[:minimum]
    end
  end
end
