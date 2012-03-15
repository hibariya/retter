# coding: utf-8

module HTMLSupport
  def texts_of(str, selector)
    Nokogiri::HTML(str).search(selector).map {|el|
      el.text.strip
    }
  end
end
