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

  it 'raises error with useful message when an unpermitted nil value is given as a value' do
    klass = create_class do
      attribute :lang, hash_of(:symbol, :string)
    end

    object = klass.new

    expect { object.lang = { php: nil } }.to raise_error do |error|
      expect(error.message).to eq('lang: Cannot be nil')
    end
  end

  it 'raises error with useful message when an unpermitted nil value is given as key' do
    klass = create_class do
      attribute :lang, hash_of(:symbol, :string)
    end

    object = klass.new

    expect { object.lang = { nil => 'cool' } }.to raise_error do |error|
      expect(error.message).to eq('lang: Cannot be nil')
    end
  end

  describe '#attributes.hash_of' do
    let(:klass) do
      create_class do
        attribute :languages, hash_of(:symbol, :string)
      end
    end

    let(:model) { klass.new }

    describe 'hash_of :symbol, :string' do
      it 'has default value of hash' do
        expect(model.languages).to eq({})
      end

      it 'converts values to hash' do
        input = {
          ruby: :Ruby,
          'php' => 'PHP is awesome'
        }

        model.languages = input

        expect(model.languages).to eq(
          ruby: 'Ruby',
          php: 'PHP is awesome'
        )

        expect(model.languages).not_to be input
      end
    end
  end
end
