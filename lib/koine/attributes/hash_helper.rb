module Koine
  module Attributes
    class HashHelper
      def symbolize_keys(hash)
        {}.tap do |new_hash|
          hash.each do |key, value|
            new_hash[key.to_sym] = value
          end
        end
      end
    end
  end
end
