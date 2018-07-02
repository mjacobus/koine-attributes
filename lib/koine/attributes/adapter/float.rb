module Koine
  module Attributes
    module Adapter
      class Float < Base
        private

        def coerce_not_nil(value)
          Float(value)
        rescue StandardError => error
          raise ArgumentError, error
        end
      end
    end
  end
end
