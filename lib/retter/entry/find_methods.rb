require 'chronic'

module Retter
  module Entry::FindMethods
    def find(date = nil, &block)
      if date
        find_by_date(date)
      elsif block
        all.find(&block)
      else
        nil
      end
    end

    def find_by_date(date)
      all.find {|e| e.date == date }
    end

    def find_by_keyword(str)
      case str = str.to_s
      when nil, ''
        return nil
      when /^e([0-9]+)$/
        find_by_index_num($1.to_i)
      when /^([0-9a-z]+\.md)$/
        find_by_file_name($1)
      else
        find(Entry::Utils.parse_date(str))
      end
    end

    def find_by_index_num(num)
      all[num]
    end

    def find_by_file_name(name)
      all.find {|entry| entry.source_path.basename.to_s == name }
    end
  end
end
