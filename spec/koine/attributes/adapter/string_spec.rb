require 'spec_helper'

RSpec.describe Koine::Attributes::Adapter::String do
  COERSIONS = {
    1        => '1',
    1.1      => '1.1',
    :symbol  => 'symbol',
    'string' => 'string'
  }.freeze

  it 'extends Base' do
    expect(subject).to be_a(Koine::Attributes::Adapter::Base)
  end

  describe '#coerce' do
    context 'with valid values' do
      COERSIONS.each do |raw, expected|
        it "coerces #{raw} into '#{expected}'" do
          coerced = subject.coerce(raw)

          expect(coerced).to eq(expected)
        end

        it "freezes '#{expected}'" do
          coerced = subject.coerce(expected)

          expect(coerced).to be_frozen
        end
      end
    end
  end
end
