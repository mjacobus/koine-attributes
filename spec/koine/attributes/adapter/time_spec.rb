# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Koine::Attributes::Adapter::Time do
  time = Time.new(2001, 1, 31, 15, 32, 33)

  it_behaves_like_an_adapter

  it_coerces Time.new(2001, 1, 31, 15, 32, 33), to: time
  it_coerces '2001-01-31 15:32:33', to: time
  it_wont_coerce 'foobar'
end
