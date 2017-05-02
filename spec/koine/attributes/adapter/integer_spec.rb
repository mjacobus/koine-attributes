require 'spec_helper'

RSpec.describe Koine::Attributes::Adapter::Integer do
  INVALID_ARGUMENTS = [
    '1foo',
    '1.1',
    '-1.1'
  ].freeze

  COERCIONS = {
    '1'       => 1,
    1.0       => 1,
    1.1       => 1,
    1.999999  => 1,
    '-1'      => -1,
    -1.0      => -1,
    -1.1      => -1,
    -1.999999 => -1
  }.freeze

  it 'extends Base' do
    expect(subject).to be_a(Koine::Attributes::Adapter::Base)
  end

  describe '#coerce' do
    specify 'returns :to_int when object implements it' do
      value = double(to_int: 10)

      expect(subject.coerce(value)).to eq(10)
    end

    COERCIONS.each do |raw_value, expected|
      it "coerces #{raw_value} coerce to #{expected}" do
        result = subject.coerce(raw_value)

        expect(result).to be(expected)
        expect(result).to be_frozen
      end
    end

    INVALID_ARGUMENTS.each do |value|
      it "raises InvalidArgument error with #{value}" do
        expect { subject.coerce(value) }.to raise_error(ArgumentError)
      end
    end
  end
end
