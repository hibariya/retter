module Retter
  class CLI::List < Thor::Group
    include CLI::Hooks

    def list
      Entry.all.each.with_index do |entry, index|
        puts %([e#{index}] #{entry.date})

        entry.articles.each do |article|
          puts %(  #{article.title})
        end
      end
    end
  end
end
