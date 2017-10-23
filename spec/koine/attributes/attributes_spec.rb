require 'spec_helper'

class DummyAdapter
  def initialize(default_value)
    @default_value = default_value
  end

  def coerce(value)
    "#{value}Coerced"
  end

  attr_reader :default_value
end

RSpec.describe Koine::Attributes::Attributes do
  let(:name) { 'John' }
  let(:last_name) { 'Doe' }
  let(:name_adapter) { DummyAdapter.new('default_name') }
  let(:last_name_adapter) { DummyAdapter.new('default_last_name') }

  let(:constructor_attributes) do
    {
      name: name_adapter,
      last_name: last_name_adapter
    }
  end

  let(:object) do
    double(name: name, last_name: last_name)
  end

  let(:attributes) { described_class.new(object, adapters: constructor_attributes) }

  describe '#to_h' do
    it 'returns the correct values' do
      expect(attributes.to_h).to eq(
        name: name,
        last_name: last_name
      )
    end
  end

  describe '#set_values' do
    it 'set values' do
      attributes.set_values('name' => 'name',
                            last_name: 'last_name')

      expect(attributes.get(:name)).to eq('nameCoerced')
      expect(attributes.get(:last_name)).to eq('last_nameCoerced')
    end
  end

  describe '#set and #get' do
    it 'can set and get' do
      attributes.set(:name, 'name')
      attributes.set(:last_name, 'last_name')

      expect(attributes.get(:name)).to eq('nameCoerced')
      expect(attributes.get(:last_name)).to eq('last_nameCoerced')
    end

    it 'can set and get via virtual attributes' do
      attributes.name = 'name'
      attributes.last_name = 'last_name'

      expect(attributes.name).to eq('nameCoerced')
      expect(attributes.last_name).to eq('last_nameCoerced')
    end
  end

  describe '#get' do
    it 'returns the default value' do
      expect(attributes.name).to eq 'default_name'
      expect(attributes.last_name).to eq 'default_last_name'
    end
  end

  describe '#respond_to?' do
    it 'respond to setter getter and with*' do
      expect(attributes).to respond_to(:name)
      expect(attributes).to respond_to(:name=)
      expect(attributes).to respond_to(:with_name)

      expect(attributes).not_to respond_to(:foo_bar)
    end
  end
end
