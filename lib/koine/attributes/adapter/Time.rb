module Koine
  module Attributes
    module Adapter
      class Time < Base
        def coerce(value)
          ensure_frozen do
            next value.dup if value.is_a?(::Time)
            ::Time.parse(value)
          end
        end
      end
    end
  end
end
