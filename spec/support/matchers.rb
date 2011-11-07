# coding: utf-8

RSpec::Matchers.define :written do
  match do |file|
    file.exist? && !file.size.zero?
  end
end

