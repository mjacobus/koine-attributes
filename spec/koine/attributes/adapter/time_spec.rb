require 'spec_helper'

RSpec.describe Koine::Attributes::Adapter::Time do
  VALID_TIMES = [
    Time.new(2001, 1, 31, 15, 32, 33),
    '2001-01-31 15:32:33'
  ].freeze

  INVALID_TIMES = [
    'foobar'
  ].freeze

  it 'extends Base' do
    expect(subject).to be_a(Koine::Attributes::Adapter::Base)
  end

  describe '#coerce' do
    VALID_TIMES.each_with_object(Time.new(2001, 1, 31, 15, 32, 33)) do |value, expected|
      it "coerces #{value} into #{expected}" do
        coerced = subject.coerce(value)

        expect(coerced).to eq(expected)
        expect(coerced).to be_frozen
      end
    end

    INVALID_TIMES.each do |value|
      it "raises ArgumentError with #{value}" do
        expect { subject.coerce(value) }.to raise_error(ArgumentError)
      end
    end

    specify 'when a Time is given it clones it' do
      time = Time.new
      coerced = subject.coerce(time)

      expect(coerced).to eq(time)
      expect(coerced).not_to be(time)
    end
  end
end
