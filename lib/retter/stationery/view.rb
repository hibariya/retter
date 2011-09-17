# coding: utf-8

module Retter::Stationery::View
  module Helper
    extend self

    def fix_path(html, prefix='./')
      elements = Nokogiri::HTML(html)

      fix_href_path(fix_src_path(elements, prefix), prefix).to_s
    end

    def entry_path(date, id = nil)
      date.strftime('/entries/%Y%m%d.html') + (id ? "##{id}" : '')
    end

    private

    def fix_src_path(elements, prefix = './')
      elements.search("[src!=''][src!='']").each do |el|
        src = el.attr('src').scan(/[^\.\/]{3}.*/).first
        next if src =~ /^(?:http|https):\/\//

        el.set_attribute 'src', [prefix, src].join
      end

      elements
    end

    def fix_href_path(elements, prefix = './')
      elements.search("[href][href!='#']").each do |el|
        href = el.attr('href')
        next if href =~ /^(?:http|https):\/\//

        if href == '/'
          el.set_attribute 'href', [prefix, 'index.html'].join
        else
          el.set_attribute 'href', [prefix, href.scan(/[^\.\/]{3}.*/).first].join
        end
      end

      elements
    end

  end

  class Scope
    attr_reader :config
    attr_accessor :assigns

    include Helper
    extend Forwardable

    def_delegators :@config, *Retter::Config.delegatables

    [:entries].each do |meth|
      define_method(meth) { @assigns[meth] }
    end

    def initialize(config, assigns = {})
      @config, @assigns = config, assigns
    end
  end
end
