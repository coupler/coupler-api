module Coupler::API
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

        [:include_fields, :include_pending].each do |key|
          if data.has_key?(key) && data[key] != false && data[key] != true
            errors.push("#{key} must be true or false")
          end
        end

        errors
      end
    end
  end
end
