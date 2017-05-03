require 'spec_helper'

RSpec.describe Koine::Attributes::Adapter::Integer do
  it_behaves_like_an_adapter

  it_wont_coerce '1foo'
  it_wont_coerce '1.1'
  it_wont_coerce '-1.1'

  it_coerces '1', to: 1, skip_dup: true
  it_coerces 1.0, to: 1, skip_dup: true
  it_coerces 1.1, to: 1, skip_dup: true
  it_coerces 1.999999, to: 1, skip_dup: true
  it_coerces '-1', to: -1, skip_dup: true
  it_coerces -1.0, to: -1, skip_dup: true
  it_coerces -1.1, to: -1, skip_dup: true
  it_coerces -1.999999, to: -1, skip_dup: true

  describe '#coerce' do
    specify 'returns :to_int when object implements it' do
      value = double(to_int: 10)

      expect(subject.coerce(value)).to eq(10)
    end
  end
end
