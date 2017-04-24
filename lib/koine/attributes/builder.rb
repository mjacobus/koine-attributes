require 'koine/attributes/hash_helper'

module Koine
  module Attributes
    class Builder
      attr_reader :attributes
      attr_reader :target

      def initialize(target:)
        @target = target
        @attributes = []
      end

      def build(name, driver)
        attributes.push(name.to_sym)
        build_getter(name, driver)
        build_setter(name, driver)
      end

      def build_getter(name, driver)
        target.class_eval do
          define_method(name) do
            instance_variable_get("@#{name}") || driver.default
          end
        end
      end

      def build_setter(name, driver)
        setter = "#{name}="

        target.class_eval do
          define_method(setter) do |*args|
            instance_variable_set("@#{name}", driver.coerce(*args))
          end
        end
      end

      def build_constructor(strict: false)
        valid_attributes = attributes

        target.class_eval do
          define_method(:initialize) do |constructor_args|
            invalid_attributes = []
            constructor_args = HashHelper.new.symbolize_keys(constructor_args)

            constructor_args.each do |name, _value|
              if valid_attributes.include?(name)
                setter = "#{name}=".to_sym
                send(setter, constructor_args[name])
                next
              end

              next unless strict
              invalid_attributes << name
            end

            unless invalid_attributes.empty?
              attributes = invalid_attributes.join(', ')
              raise ArgumentError, "Invalid attributes (#{attributes})"
            end
          end
        end
      end
    end
  end
end
