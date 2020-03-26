# frozen_string_literal: true

require 'time'

module Koine
  module Attributes
    module Adapter
      class Time < Base
        private

        def coerce_not_nil(value)
          wrap_errors do
            secure do
              next value if value.is_a?(::Time)

              ::Time.parse(value)
            end
          end
        end
      end
    end
  end
end
