module Koine
  module Attributes
    module Adapter
      class Base
        def coerce(*_values)
          raise NotImplementedError
        end

        def default_value
          @default_value.respond_to?(:call) &&
            @default_value.call ||
            @default_value
        end

        def with_default_value(value = nil, &block)
          @default_value = value
          @default_value = block if block
          self
        end

        protected

        # duplicates if possible and freezes object
        def secure
          value = yield
          value = value.dup if value.respond_to?(:dup)
          value.freeze
        end
      end
    end
  end
end
