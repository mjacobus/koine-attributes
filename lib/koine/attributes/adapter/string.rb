module Koine
  module Attributes
    module Adapter
      class String < Base
        def coerce(value)
          ensure_frozen do
            String(value)
          end
        end
      end
    end
  end
end
