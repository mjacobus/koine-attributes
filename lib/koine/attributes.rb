require 'koine/attributes/version'
require 'koine/attributes/adapter/base'

# provides the following API
#
# @example using attributes
#   class Person
#     include Koine::Attributes
#
#     attributes do
#       attribute :name, :string
#       attribute :birthday, :date
#
#       # or
#       attribute :birthday, Koine::Attributes::Adapter::Date.new
#     end
#   end
#
#   peson = Person.new
#   person.name = 'John Doe'
#   person.birtday = '2001-02-31' # Date Object can also be given
#
#   person.name # => 'John Doe'
#   person.birtday # => #<Date 2001-02-31>
#
# @example custom attribute options
#
#     attributes do
#       attribute :name, Koine::Attributes::Adapters::Date.new.with_default('guest')
#
#       # or
#       attribute :name, :string, ->(adapter) { adapter.with_default('guest') }
#     end
#
# @example Constructor for attributes
#
#   class Person
#     include Koine::Attributes
#
#     attributes initializer: true do
#       attribute :name, :string
#       attribute :birthday, :date
#     end
#   end
#
#   person = Person.new(name: 'John Doe', birthday: '2001-01-31')
#
#   # foo: attribute will raise error with strict mode
#   person = Person.new(name: 'John Doe', birthday: '2001-01-31', foo: :bar)
#
# @example Constructor for attributes withouth strict mode
#
#   class Person
#     include Koine::Attributes
#
#     attributes initializer: { strict: false } do
#       attribute :name, :string
#       attribute :birthday, :date
#     end
#   end
#
#   # foo will be ignored
#   person = Person.new(name: 'John Doe', birthday: '2001-01-31', foo: :bar)
#
# @example Override constructor
#
#   class Person
#     include Koine::Attributes
#
#     attr_reader :foo
#
#     attributes initializer: true do
#       attribute :name, :string
#       attribute :birthday, :date
#     end
#
#     def initialize(attributes = {})
#       @foo = attributes.delete(:foo)
#       self.attributes.set_values(attributes)
#     end
#   end
#
#   person = Person.new(name: 'John Doe', birthday: '2001-01-31', foo: :bar)
#   person.foo # => :bar
#
# @example
#  class Location
#    include Koine::Attributes
#
#    attributes initializer: { freeze: true } do
#      attribute :lat, :float
#      attribute :lon, :float
#    end
#  end
#
#  location = Location.new(lat: 1, lon: 2)
#  new_location = location.with_lon(3)
#
module Koine
  module Attributes
    autoload :Attributes, 'koine/attributes/attributes'
    autoload :AttributesFactory, 'koine/attributes/attributes_factory'

    module Adapter
      autoload :Any, 'koine/attributes/adapter/any'
      autoload :ArrayOf, 'koine/attributes/adapter/array_of'
      autoload :Boolean, 'koine/attributes/adapter/boolean'
      autoload :Date, 'koine/attributes/adapter/date'
      autoload :Float, 'koine/attributes/adapter/float'
      autoload :HashOf, 'koine/attributes/adapter/hash_of'
      autoload :Integer, 'koine/attributes/adapter/integer'
      autoload :String, 'koine/attributes/adapter/string'
      autoload :Symbol, 'koine/attributes/adapter/symbol'
      autoload :Time, 'koine/attributes/adapter/time'
    end

    Error = Class.new(StandardError)

    def self.included(base)
      base.extend(Forwardable)
      base.extend(ClassMethods)
    end

    module ClassMethods
      private

      def attributes(options = {}, &block)
        @builder = true
        @_attributes_factory ||= AttributesFactory.new(options)
        class_eval(&block)

        instance_eval do
          define_method :attributes do
            @_attributes ||= self.class.instance_variable_get(:@_attributes_factory).create(self)
          end

          private :attributes

          define_method(:initialize) { |*args| attributes.initialize_values(*args) }

          define_method(:inspect) do
            hex_id = '%x' % (object_id << 1)
            "#<#{self.class}:0x00#{hex_id} @attributes=#{attributes.to_h.inspect}>"
          end
        end

        @_attributes_factory.freeze

        @builder = nil
      end

      def attribute(name, adapter, lambda_arg = nil, &block)
        unless @builder
          raise Error, 'You must call .attribute inside the .attributes block'
        end

        block = lambda_arg || block
        @_attributes_factory.add_attribute(name, adapter, &block)

        instance_eval do
          define_method name do
            attributes.send(name)
          end

          define_method "#{name}=" do |value|
            attributes.send("#{name}=", value)
          end

          define_method "with_#{name}" do |value|
            attributes.send("with_#{name}", value)
          end

          define_method :== do |other|
            attributes == other.send(:attributes)
          end
        end
      end

      def array_of(item_adapter)
        adapter = @_attributes_factory.coerce_adapter(item_adapter)
        Adapter::ArrayOf.new(adapter)
      end

      def hash_of(key_adapter, value_adapter)
        key_adapter = @_attributes_factory.coerce_adapter(key_adapter)
        value_adapter = @_attributes_factory.coerce_adapter(value_adapter)
        Adapter::HashOf.new(key_adapter, value_adapter)
      end
    end
  end
end
