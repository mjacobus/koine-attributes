require 'koine/attributes/version'
require 'koine/attributes/builder'

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

      def attribute(name, driver)
        unless @builder
          raise Error, 'You must call .attribute inside the .attributes block'
        end
        @builder.build(name, driver)
      end
    end
  end
end
