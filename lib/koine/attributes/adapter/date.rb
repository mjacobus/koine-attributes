module Koine
  module Attributes
    module Adapter
      class Date < Base
        def coerce(date)
          return date if date.instance_of?(::Date)
          ::Date.parse(date)
        end
      end
    end
  end
end
