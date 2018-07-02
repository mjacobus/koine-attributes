module Koine
  module Attributes
    module Adapter
      class Base
        def coerce(value)
          return coerce_nil if value.nil?

          coerce_not_nil(value)
        end

        def default_value
          @default_value.respond_to?(:call) &&
            @default_value.call ||
            @default_value
        end

        def with_nil_value(value = nil, &block)
          @nil_value_set = true
          @nil_value = value
          @nil_value = block if block
          self
        end

        def with_default_value(value = nil, &block)
          @default_value = value
          @default_value = block if block
          self
        end

        private

        def coerce_nil
          if @nil_value_set
            return @nil_value.respond_to?(:call) ? @nil_value.call : @nil_value
          end

          raise ArgumentError, 'Cannot be nil'
        end

        def coerce_not_nil(_value)
          raise NotImplementedError
        end

        # duplicates if possible and freezes object
        def secure
          value = yield

          unless value.is_a?(::Symbol)
            value = value.dup if value.respond_to?(:dup)
          end

          value.freeze
        end

        def wrap_errors
          begin
            yield
          rescue => error
            raise ArgumentError.new(error)
          end
        end
      end
    end
  end
end
