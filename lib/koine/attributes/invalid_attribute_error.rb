# frozen_string_literal: true

module Koine
  module Attributes
    class InvalidAttributeError < ::ArgumentError
      attr_reader :attribute_name

      def initialize(error, attribute_name)
        @attribute_name = attribute_name

        if error.is_a?(Exception)
          set_backtrace(error.backtrace)
          error = error.message
        end

        error = "#{attribute_name}: #{error}" if attribute_name

        super(error)
      end
    end
  end
end
