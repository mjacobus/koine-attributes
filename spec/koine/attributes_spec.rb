require 'spec_helper'

RSpec.describe Koine::Attributes do
  let(:driver) do
    Class.new do
      attr_reader :default, :append

      def initialize(default: 'default value', append: 'coerced')
        @default = default
        @append = append
      end

      def coerce(*values)
        value = values.first
        "#{value}-#{append}"
      end
    end
  end

  let(:klass) do
    name_driver = driver.new
    last_name_driver = driver.new(default: 'default last name', append: 'last')

    Class.new do
      include Koine::Attributes

      attributes do
        attribute :name, name_driver
        attribute :last_name, last_name_driver
      end
    end
  end

  let(:klass_with_constructor) do
    name_driver = driver.new
    last_name_driver = driver.new(default: 'default last name', append: 'last')

    Class.new do
      include Koine::Attributes

      attributes initializer: { strict: false } do
        attribute :name, name_driver
        attribute :last_name, last_name_driver
      end
    end
  end

  let(:klass_with_strict_constructor) do
    name_driver = driver.new
    last_name_driver = driver.new(default: 'default last name', append: 'last')

    Class.new do
      include Koine::Attributes

      attributes initializer: true do
        attribute :name, name_driver
        attribute :last_name, last_name_driver
      end
    end
  end

  describe '.attributes -> { attribute :attribute_name, :driver }' do
    describe 'with no arguments' do
      it 'creates a getter' do
        expect(klass.new).to respond_to(:name)
        expect(klass.new).to respond_to(:last_name)
      end

      it 'creates a setter' do
        expect(klass.new).to respond_to(:name=)
        expect(klass.new).to respond_to(:last_name=)
      end

      it 'does not create a constructor' do
        expect do
          klass.new(name: 'foo')
        end.to raise_error(ArgumentError, /wrong number of arguments/)
      end
    end
  end

  describe 'getters created by the module' do
    subject { klass.new }

    it 'returns default when no value was given' do
      expect(subject.name).to eq('default value')
      expect(subject.last_name).to eq('default last name')
    end

    it 'returns the coerced value when values are set' do
      subject.name = 'john'
      subject.last_name = 'doe'

      expect(subject.name).to eq('john-coerced')
      expect(subject.last_name).to eq('doe-last')
    end
  end

  describe '.attributes initializer: option' do
    context 'when { strict: false }' do
      it 'assigns attributes from the constructor but does not raise error for invalid attributes' do
        attributes = { name: 'john', 'last_name' => 'doe', foo: 'bar' }

        subject = klass_with_constructor.new(attributes)

        expect(subject.name).to eq('john-coerced')
        expect(subject.last_name).to eq('doe-last')
      end
    end

    describe 'with initializer: true' do
      it 'assigns valid attributes from the constructor' do
        subject = klass_with_strict_constructor.new(
          name: 'john',
          'last_name' => 'doe'
        )

        expect(subject.name).to eq('john-coerced')
        expect(subject.last_name).to eq('doe-last')
      end

      it 'raises error when initialize with invalid arguments' do
        invalid_attributes = {
          name: 'john',
          'last_name' => 'doe',
          age: 18,
          'likes_footbol' => true
        }

        expect do
          klass_with_strict_constructor.new(invalid_attributes)
        end.to raise_error(ArgumentError, 'Invalid attributes (age, likes_footbol)')
      end
    end
  end

  describe '.attribute' do
    it 'raises error when called outside the block' do
      expect do
        Class.new do
          include Koine::Attributes

          attribute :name, :driver
        end
      end.to raise_error(Koine::Attributes::Error, 'You must call .attribute inside the .attributes block')
    end
  end
end
