module Koine
  module Attributes
    module Adapter
      class Float < Base
        private

        def coerce_not_nil(value)
          Float(value)
        end
      end
    end
  end
end
