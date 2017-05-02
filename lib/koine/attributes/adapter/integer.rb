module Koine
  module Attributes
    module Adapter
      class Integer < Base
        def coerce(value)
          Integer(value)
        end
      end
    end
  end
end
