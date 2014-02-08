module Retter
  class CLI::Edit < Thor::Group
    class_attribute :editor

    include CLI::Hooks

    argument :keyword, type: :string, required: false, desc: 'The keyword for an entry'

    def edit
      path = Entry.generate_entry_path(keyword)

      system editor, path.to_s
    end

    Retter.on_initialize do |config|
      self.editor = config.editor
    end
  end
end
