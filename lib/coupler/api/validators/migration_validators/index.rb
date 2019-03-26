module Coupler::API
  module MigrationValidators
    class Index
      def self.dependencies
        []
      end

      def validate(data)
        if !data.is_a?(Hash)
          raise ArgumentError, "expected argument to be a Hash"
        end

        errors = []

        errors
      end
    end
  end
end
