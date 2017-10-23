require 'spec_helper'

RSpec.describe Koine::Attributes do
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
