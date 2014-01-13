module Retter
  module StaticSite
    module App
      autoload :Application, 'retter/static_site/app/application'

      mattr_accessor :config

      Retter.on_initialize do |config|
        self.config = config
      end
    end
  end
end
