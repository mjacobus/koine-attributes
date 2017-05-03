module Koine
  module Attributes
    module Adapter
      class Boolean < Base
        DEFAULT_TRUE_VALUES = [1, '1', true, 'true'].freeze
        DEFAULT_FALSE_VALUES = [0, '0', false, 'false'].freeze

        def initialize(
          true_values: DEFAULT_TRUE_VALUES.dup,
          false_values: DEFAULT_FALSE_VALUES.dup
        )
          @true_values = true_values
          @false_values = false_values
        end

        def coerce(value)
          secure do
            next true if true_values.include?(value)
            next false if false_values.include?(value)
            raise ArgumentError, "Invalid argument '#{value}'"
          end
        end

        def append_true_value(value)
          true_values << value
          self
        end

        def append_false_value(value)
          false_values << value
          self
        end

        protected

        attr_reader :true_values
        attr_reader :false_values
      end
    end
  end
end
