module CouplerAPI
  module CsvImportValidators
    class Show
      def self.dependencies
        []
      end

      def validate(data)
        if !data.is_a?(Hash)
          raise ArgumentError, "expected argument to be a Hash"
        end

        errors = []
        if data[:id].nil?
          errors.push("id must be present")
        elsif !data[:id].is_a?(Integer)
          errors.push("id must be a number")
        end

        if data.has_key?(:row_count)
          row_count = data[:row_count]
          if !row_count.is_a?(Integer)
            errors.push("row_count must be a number")
          end
        end

        errors
      end
    end
  end
end
