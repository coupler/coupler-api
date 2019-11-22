module Coupler::API
  module DatasetExportParams
    class Show
      VALID_KEYS = %w{id}

      def self.dependencies
        []
      end

      def process(data)
        if !data.is_a?(Hash)
          raise ArgumentError, "expected argument to be a Hash"
        end

        result = {}
        data.each_pair do |key, value|
          if VALID_KEYS.include?(key)
            result[key.to_sym] = value
          end
        end
        result
      end
    end
  end
end
