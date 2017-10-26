require 'time'

module Koine
  module Attributes
    module Adapter
      class Time < Base
        private

        def coerce_not_nil(value)
          secure do
            next value if value.is_a?(::Time)
            ::Time.parse(value)
          end
        end
      end
    end
  end
end
