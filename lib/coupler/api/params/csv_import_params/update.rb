module Coupler::API
  module CsvImportParams
    class Update
      def self.dependencies
        []
      end

      def process(data)
        if !data.is_a?(Hash)
          raise ArgumentError, "expected argument to be a Hash"
        end

        result = {}
        %w{id fields}.each do |key|
          if data.has_key?(key)
            result[key.to_sym] = data[key]
          end
        end
        result
      end
    end
  end
end
