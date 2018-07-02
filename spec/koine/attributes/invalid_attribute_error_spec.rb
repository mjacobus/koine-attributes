require 'spec_helper'

RSpec.describe Koine::Attributes::InvalidAttributeError do
  describe '#message' do
    context 'when first arg is a string' do
      let(:error) { 'Invalid' }

      it 'includes attribute name in the message' do
        new_error = described_class.new(error, :attribute_name)

        expect(new_error.message).to eq('attribute_name: Invalid')
      end
    end

    context 'when first arg is an exception' do
      let(:error) { ArgumentError.new('Invalid') }

      it 'includes attribute name in the message' do
        new_error = described_class.new(error, :attribute_name)

        expect(new_error.message).to eq('attribute_name: Invalid')
      end
    end
  end
end
