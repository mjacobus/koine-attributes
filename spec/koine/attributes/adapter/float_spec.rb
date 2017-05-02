require 'spec_helper'

RSpec.describe Koine::Attributes::Adapter::Float do
  INVALID_ARGUMENTS = [
    '1foo'
  ].freeze

  COERCIONS = {
    '1'    => 1.0,
    1.0    => 1.0,
    1.1    => 1.1,
    1.99   => 1.99,
    '-1'   => -1.0,
    '-1.1' => -1.1,
    -1.0   => -1.0,
    -1.1   => -1.1,
    -1.9   => -1.9
  }.freeze

  it 'extends Base' do
    expect(subject).to be_a(Koine::Attributes::Adapter::Base)
  end

  describe '#coerce' do
    specify 'returns :to_f when object implements it' do
      value = double(to_f: 10.1)

      expect(subject.coerce(value)).to eq(10.1)
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
