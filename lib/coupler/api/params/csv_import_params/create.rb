module Coupler::API
  module CsvImportParams
    class Create
      def self.dependencies
        []
      end

      def process(data)
        if !data.is_a?(Hash)
          raise ArgumentError, "expected argument to be a Hash"
        end

        result = {}
        %w{original_name data}.each do |key|
          if data.has_key?(key)
            result[key.to_sym] = data[key]
          end
        end
        result
      end
    end
  end
end
