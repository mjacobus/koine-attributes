module Koine
  module Attributes
    class AttributesFactory
      def initialize(options = {})
        @adapters = {}
        @options = options
      end

      def create(target_object)
        Attributes.new(target_object, adapters: @adapters, options: @options)
      end

      def add_attribute(name, adapter, &block)
        adapter = coerce_adapter(adapter)
        yield(adapter) if block
        @adapters[name.to_sym] = adapter.freeze
      end

      def coerce_adapter(adapter)
        return adapter unless adapter.instance_of?(::Symbol)
        Object.const_get("Koine::Attributes::Adapter::#{adapter.to_s.capitalize}").new
      end

      def freeze
        super
        @adapters.freeze
        @options.freeze
      end
    end
  end
end
