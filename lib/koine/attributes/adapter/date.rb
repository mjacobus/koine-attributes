module Koine
  module Attributes
    module Adapter
      class Date < Base
        private

        def coerce_not_nil(date)
          secure do
            next date if date.is_a?(::Date)
            next date.to_date if date.is_a?(::Time)
            ::Date.parse(date)
          rescue => error
            raise ArgumentError.new(error)
          end
        end
      end
    end
  end
end
