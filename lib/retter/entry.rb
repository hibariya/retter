# coding: utf-8

class Retter::Entry
  class Article
    attr_accessor :entry, :id, :title, :body

    def to_s
      body
    end
  end

  attr_accessor :date, :lede, :body, :articles
  attr_reader :pathname

  def initialize(attrs={})
    @date, @body = attrs.values_at(:date, :body)

    pathname_by_date = Retter.config.retters_dir.join(date.strftime('%Y%m%d.md'))
    @pathname = attrs[:pathname] || pathname_by_date

    attach_titles
    extract_articles
    load_lede
  end

  def path
    pathname.to_s
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

  def extract_articles
    @articles = body_elements.search('body > *').each_with_object([]) {|c, r|
      if c.name == 'h1'
        article = Article.new
        article.entry = self
        article.id = c.attr('id')
        article.title = c.text
        article.body  = ''
        r << article
      else
        article  = r.last
        next if article.nil?

        article.body += c.to_s
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
