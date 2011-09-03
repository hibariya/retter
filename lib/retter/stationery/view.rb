# coding: utf-8

module Retter::Stationery::View
  module Helper
    extend self

    def fix_path(html, prefix='./')
      elements = Nokogiri::HTML(html)

      elements.search("[src!=''][src!='']").each do |el|
        src = el.attr('src').scan(/[^\.\/]{3}.*/).first
        next if src =~ /^(?:http|https):\/\//

        el.set_attribute 'src', [prefix, src].join
      end

      elements.search("[href][href!='#']").each do |el|
        href = el.attr('href')
        next if href =~ /^(?:http|https):\/\//

        if href == '/'
          el.set_attribute 'href', [prefix, 'index.html'].join
        else
          el.set_attribute 'href', [prefix, href.scan(/[^\.\/]{3}.*/).first].join
        end
      end

      elements.to_s
    end

    def entry_path(date, id = nil)
      date.strftime('/entries/%Y%m%d.html') + (id ? "##{id}" : '')
    end
  end

  class Scope
    attr_reader :config
    attr_accessor :assigns

    include Helper

    [:entries].each do |meth|
      define_method meth do
        @assigns[meth]
      end
    end

    def initialize(config, assigns = {})
      @config, @assigns = config, assigns
    end
  end
end
