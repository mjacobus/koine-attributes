module Koine
  module Attributes
    module Adapter
      class Date < Base
        def coerce(date)
          ensure_frozen do
            next date.dup if date.is_a?(::Date)
            next date.to_date if date.is_a?(::Time)
            ::Date.parse(date)
          end
        end
      end
    end
  end
end
