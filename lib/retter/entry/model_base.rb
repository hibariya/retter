module Retter
  module Entry::ModelBase
    extend ActiveSupport::Concern

    included do
      extend ActiveModel::Naming
      include ActiveModel::Conversion
    end
  end
end
