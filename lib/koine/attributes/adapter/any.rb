module Koine
  module Attributes
    module Adapter
      class Any < Base
        def coerce(value)
          secure do
            value
          end
        end
      end
    end
  end
end
