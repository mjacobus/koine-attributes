module Koine
  module Attributes
    module Adapter
      class Integer < Base
        private

        def coerce_not_nil(value)
          Integer(value)
        rescue => error
          raise ArgumentError, error
        end
      end
    end
  end
end
