require 'spec_helper'

RSpec.describe Koine::Attributes do
  let(:klass) do
    create_class do
      attribute :languages, array_of(:string)
      attribute :collection, array_of(:any)
      attribute :symbols, array_of(:symbol)
    end
  end

  let(:model) { klass.new }

  describe 'array_of :string' do
    it 'takes arrays' do
      elements = ['php', :ruby]
      model.languages = elements

      expect(model.languages).to eq(%w[php ruby])
      expect(model.languages).not_to be elements
    end
  end

  describe 'array_of :symbol' do
    it 'takes arrays' do
      model.symbols = ['php', :ruby]

      elements = ['php', :ruby]
      model.symbols = elements

      expect(model.symbols).to eq(%i[php ruby])
      expect(model.symbols).not_to be elements
    end
  end

  describe 'array_of :any' do
    it 'takes arrays' do
      elements = ['php', :ruby]
      model.collection = elements

      expect(model.collection).to eq(elements)
      expect(model.collection).not_to be elements
    end
  end
end
