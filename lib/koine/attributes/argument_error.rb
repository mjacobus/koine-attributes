module Koine
  module Attributes
    class ArgumentError < ::ArgumentError
      attr_reader :attribute_name

      def initialize(error)
        if error.is_a?(Exception)
          super(error.message)
          set_backtrace(error.backtrace)
          return
        end

        super(error)
      end
    end
  end
end
