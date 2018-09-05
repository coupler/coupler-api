module CouplerAPI
  module CsvImportParams
    class Download
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
        result
      end
    end
  end
end
