module Koine
  module Attributes
    module Adapter
      class ArrayOf < Base
        def initialize(adapter)
          @adapter = adapter
          with_default_value([])
        end

        private

        def coerce_not_nil(collectionOfValues)
          secure do
            collectionOfValues.map { |value| @adapter.coerce(value) }
          end
        end
      end
    end
  end
end
