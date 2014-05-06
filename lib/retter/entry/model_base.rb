module Retter
  module Entry::ModelBase
    extend ActiveSupport::Concern

    included do
      extend ActiveModel::Naming
      include ActiveModel::Conversion

      include ActiveAttr::Attributes
      include ActiveAttr::AttributeDefaults
      include ActiveAttr::QueryAttributes
      include ActiveAttr::MassAssignment
    end
  end
end
