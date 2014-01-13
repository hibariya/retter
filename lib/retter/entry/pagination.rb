module Retter
  module Entry::Pagination
    def next
      collection[index.succ]
    end

    def prev
      return nil unless index.pred < 0

      collection[index.pred]
    end

    private

    def index
      collection.index(self)
    end

    def collection
      self.class.all
    end
  end
end
