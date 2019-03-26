module Coupler::API
  module ComparatorParams
    class Base
      def self.dependencies
        []
      end

      def process(data)
        if !data.is_a?(Hash)
          raise ArgumentError, "expected argument to be a Hash"
        end

        result = {}
        data.each_pair do |key, value|
          if %w{kind set_1 set_2 order linkage_id options}.include?(key)
            result[key.to_sym] = value
          end
        end
        result
      end
    end
  end
end
