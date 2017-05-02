module Koine
  module Attributes
    module Adapter
      class String < Base
        def coerce(value)
          secure do
            String(value)
          end
        end
      end
    end
  end
end
