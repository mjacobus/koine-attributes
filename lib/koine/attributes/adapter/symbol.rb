module Koine
  module Attributes
    module Adapter
      class Symbol < Base
        private

        def coerce_not_nil(value)
          value.to_sym
        end
      end
    end
  end
end
