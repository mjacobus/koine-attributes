require 'koine/attributes/hash_helper'

module Koine
  module Attributes
    module Builder
      class ClassBuilder
        attr_reader :attributes
        attr_reader :target

        def initialize(target:)
          @target = target
          @attributes = []
          @getter = GetterBuilder.new(attributes: attributes, target: target)
          @setter = SetterBuilder.new(attributes: attributes, target: target)
          @constructor = ConstructorBuilder.new(attributes: attributes, target: target)
          @lazy_attributes = LazyAttributesBuilder.new(attributes: attributes, target: target)
        end

        def build(name, driver)
          attributes.push(name.to_sym)
          @getter.build(name, driver)
          @setter.build(name, driver)
        end

        def build_constructor(strict: true, freeze: false)
          @constructor.build(strict: strict, freeze: freeze)
        end

        def build_lazy_attributes
          @lazy_attributes.build
        end
      end

      class BaseBuilder
        attr_reader :attributes, :target

        def initialize(attributes:, target:)
          @attributes = attributes
          @target = target
        end
      end

      class GetterBuilder < BaseBuilder
        def build(name, driver)
          target.class_eval do
            define_method(name) do
              instance_variable_get("@#{name}") || driver.default_value
            end
          end
        end
      end

      class SetterBuilder < BaseBuilder
        def build(name, driver)
          setter = "#{name}="

          target.class_eval do
            define_method(setter) do |*args|
              instance_variable_set("@#{name}", driver.coerce(*args))
            end
          end
        end
      end

      class LazyAttributesBuilder < BaseBuilder
        def build
          valid_attributes = attributes

          target.class_eval do
            define_method :attributes do
              @_koine_attributes ||= Koine::Attributes::Attributes.new(self, attributes: valid_attributes)
            end
          end
        end
      end

      class ConstructorBuilder < BaseBuilder
        def build(strict: true, freeze: false)
          valid_attributes = attributes

          target.class_eval do
            define_method :initialize do |args = {}|
              @_koine_attributes ||= Koine::Attributes::Attributes.new(self, attributes: valid_attributes)
              initialize_attributes(args)
            end

            def attributes
              @_koine_attributes
            end

            protected

            define_method(:initialize_attributes) do |constructor_args|
              invalid_attributes = []
              constructor_args = HashHelper.new.symbolize_keys(constructor_args)

              constructor_args.each do |name, value|
                if valid_attributes.include?(name)
                  setter = "#{name}=".to_sym
                  send(setter, value)
                  next
                end

                next unless strict
                invalid_attributes << name
              end

              unless invalid_attributes.empty?
                attributes = invalid_attributes.join(', ')
                raise ArgumentError, "Invalid attributes (#{attributes})"
              end

              self.freeze if freeze
            end
          end

          if strict
            make_setters_private
            create_with_methods
            create_comparator
          end
        end

        protected

        def make_setters_private
          attrs = attributes

          target.instance_eval do
            attrs.each do |attr|
              private "#{attr}="
            end
          end
        end

        def create_with_methods
          attributes.each do |attr|
            create_with_method(attr)
          end
        end

        def create_with_method(attr)
          target.class_eval do
            define_method "with_#{attr}" do |*args|
              dup.tap do |new_object|
                new_object.send("#{attr}=", *args)
                new_object.freeze
              end
            end
          end
        end

        def create_comparator
          attrs = attributes

          target.class_eval do
            define_method :== do |that|
              a = attrs.map { |attr| send(attr) }
              b = attrs.map { |attr| that.send(attr) }
              a == b
            end
          end
        end
      end
    end
  end
end
