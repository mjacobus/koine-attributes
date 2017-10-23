require 'spec_helper'

RSpec.describe Koine::Attributes do
  let(:location_class) do
    create_class initializer: { freeze: true, strict: true } do
      attribute :lat, :float
      attribute :lon, :float
    end
  end

  describe 'class with no constructor' do
    let(:klass) do
      create_class(initializer: false) do
        attribute :name, :string
        attribute :last_name, :string
      end
    end

    it 'sets the attributes' do
      person = klass.new

      person.attributes.name = 'first'
      person.attributes.last_name = 'last'

      expect(person.attributes.name).to eq 'first'
      expect(person.attributes.last_name).to eq 'last'
    end

    it 'adds setters metters and so on' do
      person = klass.new

      person.name = 'first'
      person.last_name = 'last'

      expect(person.name).to eq 'first'
      expect(person.last_name).to eq 'last'
    end
  end

  describe '.attributes -> { attribute :attribute_name, :driver }' do
    let(:klass) do
      create_class do
        attribute :name, CustomDumbAdapter.new
        attribute :last_name, CustomDumbAdapter.new(
          default_value: 'default last name',
          append: 'last'
        )
      end
    end

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

  describe '#attributes' do
    context 'when constructor is enabled' do
      it 'returns a hash Attributes with the atrributes' do
        subject = location_class.new(lat: 123, lon: 789)

        expect(subject.attributes.to_h).to eq(
          lat: 123,
          lon: 789
        )
      end
    end

    context 'when constructor is not enabled' do
      let(:klass) do
        create_class(initializer: false) do
          attribute :name, :string
          attribute :last_name, :string
        end
      end

      it 'returns a hash Attributes with the atrributes' do
        subject = klass.new
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
    let(:klass) do
      create_class do
        attribute :name, CustomDumbAdapter.new
        attribute :last_name, CustomDumbAdapter.new(
          default_value: 'default last name',
          append: 'last'
        )
      end
    end

    it 'returns default when no value was given' do
      subject = klass.new

      expect(subject.name).to eq('default value')
      expect(subject.last_name).to eq('default last name')
    end

    it 'returns the coerced value when values are set' do
      subject = klass.new

      subject.name = 'john'
      subject.last_name = 'doe'

      expect(subject.name).to eq('john-coerced')
      expect(subject.last_name).to eq('doe-last')
    end
  end

  describe '.attributes initializer: option' do
    context 'when { strict: false }' do
      let(:klass) do
        create_class(initializer: { strict: false }) do
          attribute :name, DumbAdapter.new
          attribute :last_name, CustomDumbAdapter.new(append: 'last')
        end
      end

      it 'assigns attributes from the constructor but does not raise error for invalid attributes' do
        attributes = { name: 'john', 'last_name' => 'doe', foo: 'bar' }

        subject = klass.new(attributes)

        expect(subject.name).to eq('john-coerced')
        expect(subject.last_name).to eq('doe-last')
      end
    end

    describe 'with initializer: true' do
      let(:klass) do
        create_class initializer: true do
          attribute :name, DumbAdapter.new
          attribute :last_name, CustomDumbAdapter.new(append: 'last')
        end
      end

      it 'does not freeze object' do
        subject = klass.new

        expect(subject).not_to be_frozen
      end

      it 'can be initialized with no arguments' do
        klass.new
      end

      it 'assigns valid attributes from the constructor' do
        subject = klass.new(
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
          klass.new(invalid_attributes)
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
    let(:klass) do
      create_class initializer: true do
        attribute :date_with_object, Koine::Attributes::Adapter::Date.new.with_default_value('default_date')
        attribute :date_with_symbol, :date
        attribute :date_with_block_constructor, :date do |adapter|
          adapter.with_default_value { Date.today }
        end

        attribute :date_with_lambda_constructor, :date, ->(adapter) {
          adapter.with_default_value { Date.today }
        }
      end
    end

    subject { klass.new }

    it 'accepts adapter object' do
      default = klass.new.date_with_symbol
      coerced = klass.new(date_with_symbol: '2001-01-02').date_with_symbol

      expect(default).to eq(nil)
      expect(coerced).to eq(Date.new(2001, 0o1, 0o2))
    end

    it 'accepts adapter as symbol with block constructor' do
      default = klass.new.date_with_block_constructor
      coerced = klass.new(date_with_block_constructor: '2001-01-02')
                     .date_with_block_constructor

      expect(default).to eq(Date.today)
      expect(coerced).to eq(Date.new(2001, 1, 2))
    end

    it 'accepts adapter as symbol with lambda constructor' do
      default = klass.new.date_with_lambda_constructor
      coerced = klass.new(date_with_lambda_constructor: '2001-01-02')
                     .date_with_lambda_constructor

      expect(default).to eq(Date.today)
      expect(coerced).to eq(Date.new(2001, 1, 2))
    end
  end

  describe 'value object (with constructor: { freeze: true })' do
    subject { location_class.new(lat: 1, lon: 2) }

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
      new_location = location_class.new(lat: 1, lon: 2)

      expect(new_location).to eq(subject)
      expect(new_location.with_lat(2)).not_to eq(subject)
    end
  end
end
