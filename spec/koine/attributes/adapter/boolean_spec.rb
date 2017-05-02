require 'spec_helper'

RSpec.describe Koine::Attributes::Adapter::Boolean do
  COERSIONS = {
    true    => true,
    1       => true,
    '1'     => true,
    'true'  => true,
    'false' => false,
    '0'     => false,
    0       => false,
    false   => false
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

    context 'with unknown values' do
      it 'raises argument error' do
        value = 'yes'

        expect { subject.coerce(value) }.to raise_error(ArgumentError)
      end
    end
  end

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
