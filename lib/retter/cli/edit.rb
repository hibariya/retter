require 'bundler'

module Retter
  class CLI::Edit < Thor::Group
    class_attribute :editor

    include CLI::Hooks

    argument :keyword, type: :string, required: false, desc: 'The keyword for an entry'

    def edit
      invoke_editor Entry.find_or_build(keyword)
    end

    private

    def invoke_editor(entry)
      Bundler.with_clean_env do
        system editor, entry.source_path.to_s
      end
    end

    Retter.on_initialize do |config|
      self.editor = config.editor
    end
  end
end
