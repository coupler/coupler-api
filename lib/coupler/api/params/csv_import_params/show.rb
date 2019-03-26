module Coupler::API
  module CsvImportParams
    class Show
      def self.dependencies
        []
      end

      def process(data)
        if !data.is_a?(Hash)
          raise ArgumentError, "expected argument to be a Hash"
        end

        result = {}
        if data.has_key?('id')
          result[:id] = data['id']
        end
        if data.has_key?('row_count')
          value = data['row_count']
          if value =~ /^\d+$/
            value = value.to_i
          end
          result[:row_count] = value
        end
        result
      end
    end
  end
end
