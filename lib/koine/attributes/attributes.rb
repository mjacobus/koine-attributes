# frozen_string_literal: true

module Koine
  module Attributes
    class Attributes
      def initialize(object, adapters:, options: {})
        @object = object
        @adapters = adapters
        @values = {}
        @initializer = { strict: true, freeze: false, initialize: !options[:initializer].nil? }

        if options[:initializer].is_a?(Hash)
          @initializer = @initializer.merge(options[:initializer])
        end
      end

      def initialize_values(values = {})
        if !@initializer[:initialize] && !values.empty?
          raise InvalidAttributesError, "wrong number of arguments (given #{values.length}, expected 0)"
        end

        return unless @initializer[:initialize]

        set_values(values) && @initializer[:freeze] && freeze
      end

      def set_values(values)
        invalid_attributes = []

        if @initializer[:strict]
          attributes = values.keys.map(&:to_sym)
          invalid_attributes = attributes - valid_attributes
        end

        unless invalid_attributes.empty?
          raise InvalidAttributesError, "Invalid attributes (#{invalid_attributes.join(', ')})"
        end

        values.each do |attribute, value|
          set(attribute, value) if has_attribute?(attribute)
        end
      end

      def set(attribute, value)
        @values[attribute.to_sym] = adapter_for(attribute).coerce(value)
      end

      def with_attribute(attribute, value)
        new_attributes = to_h.merge(attribute => value)
        @object.class.new(new_attributes)
      end

      def get(attribute)
        @values[attribute.to_sym] || adapter_for(attribute).default_value
      end

      def ==(other)
        other.to_h == to_h
      end

      def to_h
        valid_attributes.map do |name|
          [name.to_sym, @object.send(name)]
        end.to_h
      end

      def respond_to?(method, _include_private = nil)
        method = method.to_s

        # getter
        return true if has_attribute?(method)

        # {attribute_name}=value
        matches = method.match(/^(.*)=$/)
        return has_attribute?(matches[1]) if matches

        # with_{attribute}(value)
        matches = method.match(/^with_(.*)$/)
        return has_attribute?(matches[1]) if matches

        false
      end

      def method_missing(method_name, *args)
        unless respond_to?(method_name)
          raise NoMethodError, "Undefined method #{method_name} for attributed object #{@object}"
        end

        method_name = method_name.to_s

        if method_name.to_s =~ /=$/
          attribute = method_name.to_s.delete('=')
          return set(attribute, *args)
        end

        matches = method_name.match(/^with_(.*)$/)
        return with_attribute(matches[1], *args) if matches

        get(method_name)
      end

      private

      def valid_attributes
        @adapters.keys
      end

      def has_attribute?(attribute)
        @adapters.key?(attribute.to_sym)
      end

      def adapter_for(attribute)
        @adapters.fetch(attribute.to_sym)
      end

      def freeze
        @object.freeze
        @adapters.freeze
        @values.freeze
        super
      end
    end
  end
end
