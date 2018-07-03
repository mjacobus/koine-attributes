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

  it 'raises error with useful message when an unpermitted nil value is given' do
    klass = create_class do
      attribute :lang, array_of(:string)
    end

    object = klass.new

    expect { object.lang = ['ruby', nil] }.to raise_error do |error|
      expect(error.message).to eq('lang: Cannot be nil')
    end
  end

  describe '#attributes.array_of' do
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
end
