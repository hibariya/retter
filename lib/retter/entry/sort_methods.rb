module Retter
  module Entry::SortMethods
    def order_by(attr)
      all.sort_by(&attr.intern)
    end
  end
end
