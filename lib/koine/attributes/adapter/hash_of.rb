module Koine
  module Attributes
    module Adapter
      class HashOf < Base
        def initialize(key_adapter, value_adapter)
          @key_adapter = key_adapter || raise(ArgumentError, 'Invalid key adapter')
          @value_adapter = value_adapter || raise(ArgumentError, 'Invalid value adapter')
          with_default_value({})
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
