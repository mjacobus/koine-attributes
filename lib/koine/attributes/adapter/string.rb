# frozen_string_literal: true

module Koine
  module Attributes
    module Adapter
      class String < Base
        def empty_to_nil
          with_nil_value(nil)
          @empty_to_nil = true
          self
        end

        def trim_empty_spaces
          @trim_empty_spaces = true
          self
        end

        private

        def coerce_not_nil(value)
          secure do
            value = String(value)
            value = value.strip if @trim_empty_spaces
            return nil if value.empty? && @empty_to_nil

            value
          end
        end
      end
    end
  end
end
