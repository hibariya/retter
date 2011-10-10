# coding: utf-8

class Retter::Entry
  class Part
    attr_accessor :entry, :id, :title, :body

    def to_s
      body
    end
  end

  attr_accessor :date, :lede, :body, :parts

  def initialize(attrs={})
    @date, @body = attrs.values_at(:date, :body)

    attach_titles
    extract_entry_parts
    load_lede
  end

  def to_s
    body
  end

  private

  def body_elements
    Nokogiri::HTML(body)
  end

  def attach_titles
    html = body_elements
    html.search('//h1').each_with_index do |h1, seq|
      h1.set_attribute 'id', "a#{seq}"
    end

    @body = html.search('//body/*').to_s
  end

  def extract_entry_parts
    @parts = body_elements.search('body > *').each_with_object([]) {|c, r|
      if c.name == 'h1'
        part = Part.new
        part.entry = self
        part.id = c.attr('id')
        part.title = c.text
        part.body  = ''
        r << part
      else
        part  = r.last
        next if part.nil?

        part.body += c.to_s
      end
    } || []
  end

  def load_lede
    @lede = body_elements.search('body > *').each_with_object('') {|c, r|
      break r if c.name == 'h1'
      r<< c.to_s
    }
  end
end
