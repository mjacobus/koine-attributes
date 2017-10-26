require 'spec_helper'

RSpec.describe Koine::Attributes::Adapter::Float do
  INVALID_ARGUMENTS = [
    '1foo'
  ].freeze

  it_coerces '1', to: 1.0, skip_dup: true
  it_coerces 1.0, to: 1.0, skip_dup: true
  it_coerces 1.1, to: 1.1, skip_dup: true
  it_coerces 1.99, to: 1.99, skip_dup: true
  it_coerces '-1', to: -1.0, skip_dup: true
  it_coerces '-1.1', to: -1.1, skip_dup: true
  it_coerces -1.0, to: -1.0, skip_dup: true
  it_coerces -1.1, to: -1.1, skip_dup: true
  it_coerces -1.9, to: -1.9, skip_dup: true

  it 'extends Base' do
    expect(subject).to be_a(Koine::Attributes::Adapter::Base)
  end

  describe '#coerce' do
    specify 'returns :to_f when object implements it' do
      value = double(to_f: 10.1)

      expect(subject.coerce(value)).to eq(10.1)
    end

    INVALID_ARGUMENTS.each do |value|
      it "raises InvalidArgument error with #{value}" do
        expect { subject.coerce(value) }.to raise_error(ArgumentError)
      end
    end
  end

  describe '#with_nil_value' do
    describe 'not set' do
      it 'raises an exception' do
        expect do
          subject.coerce(nil)
        end.to raise_error(ArgumentError, 'Cannot be nil')
      end
    end

    describe 'set to nil' do
      subject { described_class.new.with_nil_value }

      it 'returns nil' do
        expect(subject.coerce(nil)).to be_nil
      end
    end

    describe 'set to 0' do
      subject { described_class.new.with_nil_value(0) }

      it 'returns 0' do
        expect(subject.coerce(nil)).to be 0
      end
    end

    describe 'set to a block' do
      subject do
        described_class.new.with_nil_value do
          10.12
        end
      end

      it 'returns 0' do
        expect(subject.coerce(nil)).to eq 10.12
      end
    end
  end
end
