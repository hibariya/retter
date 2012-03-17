# coding: utf-8

require 'albino/multi'
require 'digest/sha1'

Albino::Multi.timeout_threshold = 60

module Retter
  module Renderers
    class CodeRayRenderer < Redcarpet::Render::HTML
      def block_code(code, lang)
        CodeRay.scan(code, lang ? lang.intern : :plain).div
      end
    end

    class AlbinoRenderer < Redcarpet::Render::HTML
      def preprocess(doc)
        @block_codes = {}

        doc
      end

      def block_code(code, lang)
        key = Digest::SHA1.hexdigest("#{lang} #{code}")
        @block_codes[key] = [code, lang]

        key
      end

      def postprocess(doc)
        process_block_codes

        @block_codes.each do |key, code|
          doc.gsub! key, code
        end

        doc
      end

      def process_block_codes
        @block_codes.map { |key, (code, lang)|
          Thread.fork {
            @block_codes[key] = Albino.colorize(code, (lang || 'text'))
          }
        }.map(&:join)
      end
    end
  end
end
