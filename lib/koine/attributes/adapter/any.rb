module Koine
  module Attributes
    module Adapter
      class Any < Base
        private

        def coerce_not_nil(value)
          secure do
            value
          end
        end
      end
    end
  end
end
