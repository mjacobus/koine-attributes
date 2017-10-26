module Koine
  module Attributes
    module Adapter
      class Integer < Base
        private

        def coerce_not_nil(value)
          Integer(value)
        end
      end
    end
  end
end
