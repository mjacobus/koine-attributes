require 'spec_helper'

RSpec.describe Koine::Attributes do
  it 'sets the attributes' do
    person = PersonWithNoConstructor.new

    person.attributes.name = 'first'
    person.attributes.last_name = 'last'

    expect(person.attributes.name).to eq 'first'
    expect(person.attributes.last_name).to eq 'last'
  end

  it 'adds setters metters and so on' do
    person = PersonWithNoConstructor.new

    person.name = 'first'
    person.last_name = 'last'

    expect(person.name).to eq 'first'
    expect(person.last_name).to eq 'last'
  end

  describe '.attributes -> { attribute :attribute_name, :driver }' do
    describe 'with no arguments' do
      it 'creates a getter' do
        expect(ExampleClass.new).to respond_to(:name)
        expect(ExampleClass.new).to respond_to(:last_name)
      end

      it 'creates a setter' do
        expect(ExampleClass.new).to respond_to(:name=)
        expect(ExampleClass.new).to respond_to(:last_name=)
      end

      it 'does not create a constructor' do
        expect do
          ExampleClass.new(name: 'foo')
        end.to raise_error(ArgumentError, /wrong number of arguments/)
      end
    end
  end

  describe '#attributes' do
    context 'when constructor is enabled' do
      it 'returns a hash Attributes with the atrributes' do
        subject = Location.new(lat: 123, lon: 789)

        expect(subject.attributes.to_h).to eq(
          lat: 123,
          lon: 789
        )
      end
    end

    context 'when constructor is not enabled' do
      it 'returns a hash Attributes with the atrributes' do
        subject = PersonWithNoConstructor.new
        subject.name = 'foo'
        subject.last_name = 'bar'

        expect(subject.attributes.to_h).to eq(
          name: 'foo',
          last_name: 'bar'
        )
      end
    end
  end

  describe 'getters created by the module' do
    subject { ExampleClass.new }

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

        subject = ExampleClassWithConstructor.new(attributes)

        expect(subject.name).to eq('john-coerced')
        expect(subject.last_name).to eq('doe-last')
      end
    end

    describe 'with initializer: true' do
      it 'does not freeze object' do
        subject = ExampleClassWithStrictConstructor.new

        expect(subject).not_to be_frozen
      end

      it 'can be initialized with no arguments' do
        ExampleClassWithStrictConstructor.new
      end

      it 'assigns valid attributes from the constructor' do
        subject = ExampleClassWithStrictConstructor.new(
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
          ExampleClassWithStrictConstructor.new(invalid_attributes)
        end.to raise_error(ArgumentError, 'Invalid attributes (age, likes_footbol)')
      end
    end
  end

  describe '.attribute' do
    it 'raises error when called outside the .attributes block' do
      expect do
        Class.new do
          include Koine::Attributes
          attribute :name, :adapter
        end
      end.to raise_error(Koine::Attributes::Error, 'You must call .attribute inside the .attributes block')
    end
  end

  describe '.attribute with :symbol definition' do
    subject { ExampleWithDate.new }

    it 'accepts adapter object' do
      default = ExampleWithDate.new.date_with_symbol
      coerced = ExampleWithDate.new(date_with_symbol: '2001-01-02').date_with_symbol

      expect(default).to eq(nil)
      expect(coerced).to eq(Date.new(2001, 0o1, 0o2))
    end

    it 'accepts adapter as symbol with block constructor' do
      default = ExampleWithDate.new.date_with_block_constructor
      coerced = ExampleWithDate.new(date_with_block_constructor: '2001-01-02')
                               .date_with_block_constructor

      expect(default).to eq(Date.today)
      expect(coerced).to eq(Date.new(2001, 1, 2))
    end

    it 'accepts adapter as symbol with lambda constructor' do
      default = ExampleWithDate.new.date_with_lambda_constructor
      coerced = ExampleWithDate.new(date_with_lambda_constructor: '2001-01-02')
                               .date_with_lambda_constructor

      expect(default).to eq(Date.today)
      expect(coerced).to eq(Date.new(2001, 1, 2))
    end
  end

  describe 'value object (with constructor: { freeze: true })' do
    subject { Location.new(lat: 1, lon: 2) }

    it 'freezes object' do
      expect(subject).to be_frozen
      # expect(subject.attributes).to be_frozen
    end

    it 'cannot mutate object' do
      expect do
        subject.lat = 10
      end.to raise_error(RuntimeError, /frozen/)

      expect(subject.lat).not_to eq 10
    end

    it 'has getter' do
      expect(subject.lat).to eq(1)
      expect(subject.lon).to eq(2)
    end

    it 'creates a new object with the "with_{attribute}" method' do
      new_location = subject.with_lat(3)

      expect(new_location.lat).to eq(3)
      expect(new_location.lon).to eq(2)
      expect(new_location.with_lon(10).lon).to eq(10)

      expect(new_location).not_to be(subject)
      expect(new_location).to be_frozen
      expect(subject).to be_frozen
    end

    it 'can be compared with other objects' do
      new_location = Location.new(lat: 1, lon: 2)

      expect(new_location).to eq(subject)
      expect(new_location.with_lat(2)).not_to eq(subject)
    end
  end
end
