require 'koine/attributes/version'
require 'koine/attributes/builder'
require 'koine/attributes/adapter/base'

# provides the following API
#
# @example using attributes
#   class Person
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
#     attr_reader :foo
#
#     attributes initializer: true do
#       attribute :name, :string
#       attribute :birthday, :date
#     end
#
#     def initializ(attributes = {})
#       @foo = attributes.delete(:foo)
#
#       initialize_attributes(attributes) # protected
#     end
#   end
#
#   person = Person.new(name: 'John Doe', birthday: '2001-01-31', foo: :bar)
#   person.foo # => :bar
#
module Koine
  module Attributes
    module Adapter
      autoload :Date, 'koine/attributes/adapter/date'
      autoload :String, 'koine/attributes/adapter/string'
    end

    Error = Class.new(StandardError)

    def self.included(base)
      base.extend(ClassMethods)
    end

    module ClassMethods
      def attributes(options = {}, &block)
        @builder = Builder.new(target: self)
        class_eval(&block)

        if options[:initializer]
          initializer_options = options[:initializer]

          initializer_options = {} unless initializer_options.is_a?(Hash)

          @builder.build_constructor(initializer_options)
        end

        @builder = nil
      end

      def attribute(name, adapter, lambda_constructor = nil, &block)
        unless @builder
          raise Error, 'You must call .attribute inside the .attributes block'
        end

        adapter = coerce_adapter(adapter, lambda_constructor, &block)
        @builder.build(name, adapter)
      end

      private def coerce_adapter(adapter, lambda_constructor, &block)
        return adapter unless adapter.instance_of?(::Symbol)
        adapter = const_get("Koine::Attributes::Adapter::#{adapter.to_s.capitalize}").new
        lambda_constructor.call(adapter) if lambda_constructor
        yield(adapter) if block
        adapter
      end
    end
  end
end
