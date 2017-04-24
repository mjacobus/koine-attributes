require 'koine/attributes/version'
require 'koine/attributes/builder'

# provides the following API
#
#   ```ruby
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
#   ```
#
#   ```ruby
#     attributes do
#       attribute :name, Koine::Attributes::Adapters::Date.new.with_default('guest')
#
#       # or
#       attribute :name, :string, ->(adapter) { adapter.with_default('guest') }
#     end
#   ```
#
# Also, a constructor can be created by the API
#
#   ```ruby
#   class Person
#     attributes initializer: true do
#       attribute :name, :string
#       attribute :birthday, :date
#     end
#   end
#
#   person = Person.new(name: 'John Doe', birthday: '2001-01-31')
#
#   foo: attribute will raise error
#   person = Person.new(name: 'John Doe', birthday: '2001-01-31', foo: :bar)
#   ```
#
# You can disable strict mode
#
#   ```ruby
#   class Person
#     attributes initializer: { strict: false } do
#       attribute :name, :string
#       attribute :birthday, :date
#     end
#   end
#
#   # foo will be ignored
#   person = Person.new(name: 'John Doe', birthday: '2001-01-31', foo: :bar)
#   ```
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
