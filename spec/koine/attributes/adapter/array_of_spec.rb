require 'spec_helper'

RSpec.describe Koine::Attributes::Adapter::ArrayOf do
  subject { described_class.new(double) }

  it_behaves_like_an_adapter

  specify 'its default value is []' do
    expect(subject.default_value).to eq([])
  end

  describe 'with customized adapter' do
    let(:klass) do
      create_class do
        attribute :allowed_values, array_of(:string) do |adapter|
          adapter.for_values.with_nil_value
        end
      end
    end

    describe 'for instance when it can be nil' do
      it 'takes nil' do
        model = klass.new
        values = ['foo', nil, 'bar']

        model.allowed_values = values

        expect(model.allowed_values).to eq(values)
      end
    end
  end
end
