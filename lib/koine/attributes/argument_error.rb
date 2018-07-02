module Koine
  module Attributes
    class ArgumentError < ::ArgumentError
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
