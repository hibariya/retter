# coding: utf-8

class Retter::Entry
  attr_accessor :date, :body, :titles

  def initialize(attrs={})
    @date, @body = attrs.values_at(:date, :body)

    attach_titles
    load_titles
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

  def load_titles
    @titles = body_elements.search('//h1').each_with_object({}) {|h1, titles|
      titles[h1.attr('id')] = h1.text
    }
  end
end
