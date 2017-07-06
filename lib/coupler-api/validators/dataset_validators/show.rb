module CouplerAPI
  module DatasetValidators
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

        key = :include_fields
        if data[key] && data[key] != false && data[key] != true
          errors.push("include_fields must be true or false")
        end

        errors
      end
    end
  end
end
