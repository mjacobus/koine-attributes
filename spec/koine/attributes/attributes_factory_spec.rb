# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Koine::Attributes::AttributesFactory do
  let(:target) { double }
  let(:factory) do
    described_class.new.tap do |f|
      f.add_attribute(:name, Koine::Attributes::Adapter::String.new)
      f.add_attribute :last_name, :string do |adapter|
        adapter.with_default_value('[nobody]')
      end
    end
  end

  it 'can create a new attributes set' do
    attributes = factory.create(target)

    expect(attributes.last_name).to eq '[nobody]'

    attributes.name = 'name'
    attributes.last_name = 'last_name'

    expect(attributes.name).to eq 'name'
    expect(attributes.last_name).to eq 'last_name'
  end
end
