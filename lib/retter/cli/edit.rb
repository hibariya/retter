module Retter
  class CLI::Edit < Thor::Group
    class_attribute :editor

    include CLI::Hooks

    argument :keyword, type: :string, required: false, desc: 'The keyword for an entry'

    def edit
      path = Entry.generate_entry_path(keyword)

      invoke_editor editor, path
    end

    private

    def invoke_editor(editor, path)
      invoke_proc = -> { system editor, path.to_s }

      if Object.const_defined?(:Bundler)
        Bundler.with_clean_env do
          invoke_proc.call
        end
      else
        invoke_proc.call
      end
    end

    Retter.on_initialize do |config|
      self.editor = config.editor
    end
  end
end
