module Retter::Entry::Utils
  module_function

  def parse_date(str)
    str          = str.to_s.gsub(/\./, ' ')
    date_or_time = (Chronic.parse(str) || Date.parse(str)) rescue nil

    return nil unless date_or_time

    date_or_time.to_date
  end
end
