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

        if data[:filename].nil? || data[:filename].empty?
          errors.push("filename must be present")
        elsif !data[:filename].is_a?(String)
          errors.push("filename is not valid")
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
