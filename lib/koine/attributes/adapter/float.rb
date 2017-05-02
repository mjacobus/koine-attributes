module Koine
  module Attributes
    module Adapter
      class Float < Base
        def coerce(value)
          Float(value)
        end
      end
    end
  end
end

