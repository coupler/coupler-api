module CouplerAPI
  module CsvImportValidators
    class Create
      def self.dependencies
        []
      end

      def validate(data)
        if !data.is_a?(Hash)
          raise ArgumentError, "expected argument to be a Hash"
        end

        errors = []

        if data[:original_name].nil? || data[:original_name].empty?
          errors.push("original_name must be present")
        elsif !data[:original_name].is_a?(String)
          errors.push("original_name is not valid")
        end

        if data[:data].nil? || data[:data].empty?
          errors.push("data must be present")
        elsif !data[:data].is_a?(String)
          errors.push("data is not valid")
        end

        errors
      end
    end
  end
end
