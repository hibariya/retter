module Retter
  module StaticSite
    class CLI::Edit < Retter::CLI::Edit
      class_attribute :source_branch

      Retter.on_initialize do |config|
        self.source_branch = config.source_branch
      end

      def edit
        StaticSite::Repository.checkout source_branch do
          super
        end
      end
    end
  end
end
