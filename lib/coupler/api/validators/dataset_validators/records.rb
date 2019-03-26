module Coupler::API
  module DatasetValidators
    class Records
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
          errors.push("id must be an integer")
        end

        if data[:limit].nil?
          errors.push("limit must be present")
        elsif !data[:limit].is_a?(Integer)
          errors.push("limit must be an integer")
        end

        if data[:offset].nil?
          errors.push("offset must be present")
        elsif !data[:offset].is_a?(Integer)
          errors.push("offset must be an integer")
        end

        errors
      end
    end
  end
end
