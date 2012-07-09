# coding: utf-8

require 'active_support/cache'
require 'digest/sha1'
require 'redcarpet'
require 'chronic'

module Retter
  class EntryLoadError < RetterError; end

  class Entries < Array
    extend Configurable
    include Site

    configurable :renderer, :retters_dir, :wip_file, :markup

    def initialize
      load_entries retters_dir
    end

    def retter_file(date)
      retters_dir.join(date ? date.strftime('%Y%m%d.md') : 'today.md')
    end

    def detect_by_string(str)
      entry =
        case str
        when nil, ''
          detect_by_today || wip_entry
        when /^e([0-9]+)$/
          index = $1.to_i
          self[index]
        when /^([0-9a-z]+\.md)$/
          detect_by_filename($1)
        else
          date = parse_date_string(str)
          detect_by_date(date) || wip_entry(date)
        end

      raise EntryLoadError, "Entry not found with keyword '#{str}'" unless entry

      entry
    end

    def detect_by_filename(filename)
      case filename
      when wip_file.basename.to_path
        wip_entry
      else
        detect {|e| e.pathname.basename.to_path == filename }
      end
    end

    def detect_by_today
      detect_by_date(Date.today)
    end

    def detect_by_date(date)
      detect {|e| e.date == date }
    end

    def parse_date_string(date_str)
      normalized = date_str.gsub(/\./, ' ')

      (Chronic.parse(normalized) || Date.parse(normalized)).to_date
    end

    def wip_entry(date = nil)
      file = retter_file(date)
      date = date || Date.today
      body = file.exist? ? file.read : ''

      Entry.new date: date, body: rendered_body(body), pathname: file
    end

    def commit_wip_entry!
      if wip_file.exist?
        copy = wip_file.read
        retter_file(Date.today).open('a') {|f| f.puts copy }
        wip_file.unlink
      end

      reset!
    end

    def load_entries(path)
      date_files = find_markup_files(path).map {|file|
        date_str = file.basename('.*').to_path
        [Date.parse(date_str), file]
      }.sort_by(&:first)

      date_files.reverse_each {|date, file|
        self << Entry.new(date: date, body: rendered_body(file.read))
      }
    end

    def find_markup_files(path)
      path = Pathname.new(path).realpath
      Dir.open(path, &:to_a).grep(/^\d{4}(?:0[1-9]|1[012])(?:0[1-9]|[12][0-9]|3[01])\.(md)$/).map {|f| path.join f }
    end

    def rendered_body(body)
      key = Digest::SHA1.hexdigest('entry_' + body)

      config.cache.fetch(key) do
        (markup || markup_builtin).render(body)
      end
    end

    def markup_builtin
      Redcarpet::Markdown.new(
        renderer,
        autolink: true,
        space_after_headers: true,
        fenced_code_blocks: true,
        strikethrough: true,
        superscript: true,
        fenced_code_blocks: true,
        tables: true
      )
    end
  end
end
