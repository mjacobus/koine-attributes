require 'spec_helper'

RSpec.describe Koine::Attributes::Adapter::Boolean do
  it_behaves_like_an_adapter

  it_coerces true, to: true, skip_frozen: true, skip_dup: true
  it_coerces 1, to: true, skip_frozen: true, skip_dup: true
  it_coerces '1', to: true, skip_frozen: true, skip_dup: true
  it_coerces 'true', to: true, skip_frozen: true, skip_dup: true
  it_coerces 'false', to: false, skip_frozen: true, skip_dup: true
  it_coerces '0', to: false, skip_frozen: true, skip_dup: true
  it_coerces 0, to: false, skip_frozen: true, skip_dup: true
  it_coerces false, to: false, skip_frozen: true, skip_dup: true

  it_wont_coerce 'yes'

  describe '#append_true_value' do
    it 'appends a truthy value' do
      coerced = subject.append_true_value('yes').coerce('yes')

      expect(coerced).to be(true)
    end
  end

  describe '#append_false_value' do
    it 'appends a truthy value' do
      coerced = subject.append_false_value('no').coerce('no')

      expect(coerced).to be(false)
    end
  end
end
