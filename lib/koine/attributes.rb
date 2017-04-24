require 'koine/attributes/version'
require 'koine/attributes/builder'

module Koine
  module Attributes
    def self.included(base)
      base.extend(ClassMethods)
    end

    module ClassMethods
      def attributes(options = {}, &block)
        @builder = Builder.new(target: self)
        class_eval(&block)

        if options[:initializer]
          initializer_options = options[:initializer]

          initializer_options = {} unless initializer_options.is_a?(Hash)

          @builder.build_constructor(initializer_options)
        end

        @builder = nil
      end

      def attribute(name, driver)
        @builder.build(name, driver)
      end
    end
  end
end
