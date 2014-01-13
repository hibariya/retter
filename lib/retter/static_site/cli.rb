require 'retter/cli'

module Retter
  module StaticSite
    module CLI
      autoload :Build,   'retter/static_site/cli/build'
      autoload :Edit,    'retter/static_site/cli/edit'
      autoload :Migrate, 'retter/static_site/cli/migrate'
      autoload :New,     'retter/static_site/cli/new'
      autoload :Preview, 'retter/static_site/cli/preview'

      module Command
        extend ActiveSupport::Concern

        included do
          register Build,   'build',   'build',                              'Build all entries'
          register Edit,    'edit',    'edit [KEYOWRD]',                     'Open an entry with $EDITOR'
          register Migrate, 'migrate', 'migrate',                            'Migrate site for retter current version'
          register New,     'new',     'new NAME',                           'Create a new site'
          register Preview, 'preview', 'preview [PATH][--livereload=false]', 'Preview on browser w/ livereload'
        end
      end
    end
  end
end
