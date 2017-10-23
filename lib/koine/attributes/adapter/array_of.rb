module Koine
  module Attributes
    module Adapter
      class ArrayOf < Base
        def initialize(adapter)
          @adapter = adapter
        end

        def coerce(collectionOfValues)
          secure do
            collectionOfValues.map { |value| @adapter.coerce(value) }
          end
        end
      end
    end
  end
end
