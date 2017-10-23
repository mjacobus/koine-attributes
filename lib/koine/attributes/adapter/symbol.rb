module Koine
  module Attributes
    module Adapter
      class Symbol < Base
        def coerce(value)
          value.to_sym
        end
      end
    end
  end
end
