# frozen_string_literal: true

module Koine
  module Attributes
    module Adapter
      class Integer < Base
        private

        def coerce_not_nil(value)
          wrap_errors { Integer(value) }
        end
      end
    end
  end
end
