module CouplerAPI
  module DatasetValidators
    class Index
      def self.dependencies
        []
      end

      def validate(data)
        if !data.is_a?(Hash)
          raise ArgumentError, "expected argument to be a Hash"
        end

        errors = []

        key = :include_fields
        if data.has_key?(key) && data[key] != false && data[key] != true
          errors.push("include_fields must be true or false")
        end

        errors
      end
    end
  end
end
