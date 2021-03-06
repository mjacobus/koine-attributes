# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Koine::Attributes::Adapter::Date do
  before do
    subject.with_attribute_name('date')
  end

  it_behaves_like_an_adapter

  it_coerces Date.new(2001, 1, 31), to: Date.new(2001, 1, 31)
  it_coerces Time.new(2001, 1, 31), to: Date.new(2001, 1, 31)
  it_coerces '2001-01-31', to: Date.new(2001, 1, 31)
  it_coerces '2001-01-31 01:02:03', to: Date.new(2001, 1, 31)

  it_wont_coerce 'foobar'
end
