# coding: utf-8

RSpec::Matchers.define :written do
  match do |file|
    file.exist? && !file.size.zero?
  end
end

RSpec::Matchers.define :be_exit_successfully do
  match do |actual|
    actual.status.success?
  end

  failure_message_for_should do |actual|
    "expected that result would be success. (#{actual.inspect})"
  end

  failure_message_for_should_not do |actual|
    "expected that result would not be success. (#{actual.inspect})"
  end
end
