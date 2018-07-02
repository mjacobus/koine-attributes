require 'spec_helper'

RSpec.describe Koine::Attributes::Adapter::ArrayOf do
  subject { described_class.new(double) }

  it_behaves_like_an_adapter

  describe 'with optional value' do
    let(:klass) do
      Class.new do
        include Koine::Attributes

        attributes initializer: true do
          attribute :config, hash_of(:symbol, :string) do |adapter|
            adapter.for_values.with_nil_value
          end
        end
      end
    end

    let(:values) { { foo: 'bar', bar: nil } }

    it 'allows optinal' do
      object = klass.new(config: values)

      expect(object.config).to eq(values)
    end

    it 'allows on setter as well' do
      object = klass.new
      object.config = values

      expect(object.config).to eq(values)
    end
  end
end
