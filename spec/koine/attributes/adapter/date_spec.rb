require 'spec_helper'

RSpec.describe Koine::Attributes::Adapter::Date do
  VALID_DATES_VALUES = [
    Date.new(2001, 1, 31),
    Time.new(2001, 1, 31),
    '2001-01-31',
    '2001-01-31 01:02:03'
  ].freeze

  INVALID_DATES_VALUES = [
    'foobar'
  ].freeze

  it 'extends Base' do
    expect(subject).to be_a(Koine::Attributes::Adapter::Base)
  end

  describe '#coerce' do
    context 'with valid values' do
      VALID_DATES_VALUES.each_with_object(Date.new(2001, 1, 31)) do |value, date|
        it "coerces #{value} into #{date}" do
          coerced = subject.coerce(value)

          expect(coerced).to eq(date)
        end

        it "freezes #{date}" do
          coerced = subject.coerce(value)

          expect(coerced.frozen?).to eq(true)
        end
      end
    end

    context 'with valid values' do
      INVALID_DATES_VALUES.each do |value|
        it "with #{value} raises ArgumentError error" do
          expect { subject.coerce(value) }.to raise_error(ArgumentError)
        end
      end
    end

    specify 'when a date is given it clones it' do
      date = ::Date.new(2001, 1, 31)
      coerced = subject.coerce(date)

      expect(coerced).to eq(date)
      expect(coerced).not_to be(date)
    end
  end
end