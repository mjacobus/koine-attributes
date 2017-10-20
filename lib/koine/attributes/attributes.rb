module Koine
  module Attributes
    class Attributes
      def initialize(object, attributes:)
        @object = object
        @attributes = attributes
      end

      def to_h
        {}.tap do |hash|
          @attributes.each do |name|
            hash[name.to_sym] = @object.send(name)
          end
        end
      end
    end
  end
end
