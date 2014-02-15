module Retter
  module StaticSite
    class CLI::Edit < Retter::CLI::Edit
      class_attribute :source_branch

      def edit
        Repository.checkout source_branch do
          super
        end
      end

      Retter.on_initialize do |config|
        self.source_branch = config.source_branch
      end
    end
  end
end
