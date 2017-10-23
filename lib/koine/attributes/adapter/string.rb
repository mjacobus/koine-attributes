module Koine
  module Attributes
    module Adapter
      class String < Base
        def empty_to_nil
          @empty_to_nil = true
          self
        end

        def trim_empty_spaces
          @trim_empty_spaces = true
          self
        end

        def coerce(value)
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
