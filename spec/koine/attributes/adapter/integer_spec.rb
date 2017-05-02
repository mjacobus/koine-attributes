require 'spec_helper'

RSpec.describe Koine::Attributes::Adapter::Integer do
  INVALID_ARGUMENTS = [
    '1foo'
  ].freeze

  COERCIONS = {
    '1'      => 1,
    '1.1'    => 1,
    1.0      => 1,
    1.1      => 1,
    1.999999 => 1
  }.freeze

  it 'extends Base' do
    expect(subject).to be_a(Koine::Attributes::Adapter::Base)
  end

  describe '#coerce' do
    COERCIONS.each do |raw_value, expected|
      let(:result) { subject.coerce(raw_value) }

      it "coerces #{raw_value} coerce to #{expected}" do
        expect(result).to be(expected)
      end
    end

    INVALID_ARGUMENTS.each do |value|
      context "with invalid value value #{value}" do
        it 'raises argument error' do
          expect { subject.coerce(value) }.to raise_error(ArgumentError)
        end
      end
    end
  end
end
