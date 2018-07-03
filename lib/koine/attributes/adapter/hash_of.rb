module Koine
  module Attributes
    module Adapter
      class HashOf < Base
        def initialize(key_adapter, value_adapter)
          @key_adapter = key_adapter || raise(ArgumentError, 'Invalid key adapter')
          @value_adapter = value_adapter || raise(ArgumentError, 'Invalid value adapter')
          with_default_value({})
        end

        def for_keys
          @key_adapter
        end

        def for_values
          @value_adapter
        end

        def with_attribute_name(name)
          @key_adapter.with_attribute_name(name)
          @value_adapter.with_attribute_name(name)
          super(name)
        end

        private

        def coerce_not_nil(hash)
          secure do
            {}.tap do |new_hash|
              hash.each do |key, value|
                key = @key_adapter.coerce(key)
                value = @value_adapter.coerce(value)
                new_hash[key] = value
              end
            end
          end
        end
      end
    end
  end
end
