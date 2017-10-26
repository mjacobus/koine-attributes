require 'spec_helper'

RSpec.describe Koine::Attributes::Adapter::String do
  it_behaves_like_an_adapter

  it_coerces 1, to: '1'
  it_coerces 1.1, to: '1.1'
  it_coerces :symbol, to: 'symbol'
  it_coerces 'string', to: 'string'
  # it_coerces nil, to: ''

  describe 'default value can be changed to nil' do
    before do
      subject.empty_to_nil
    end

    it_coerces nil, to: nil, skip_dup: true
  end

  describe 'default value can be changed to nil' do
    before do
      subject.trim_empty_spaces.empty_to_nil
    end

    it_coerces ' f ', to: 'f'
    it_coerces '  ', to: nil, skip_dup: true
  end
end
