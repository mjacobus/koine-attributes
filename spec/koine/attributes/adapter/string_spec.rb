require 'spec_helper'

RSpec.describe Koine::Attributes::Adapter::String do
  it_behaves_like_an_adapter

  it_coerces 1, to: '1'
  it_coerces 1.1, to: '1.1'
  it_coerces :symbol, to: 'symbol'
  it_coerces 'string', to: 'string'
end
