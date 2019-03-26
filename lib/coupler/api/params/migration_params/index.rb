module Coupler::API
  module MigrationParams
    class Index
      def self.dependencies
        []
      end

      def process(data)
        if !data.is_a?(Hash)
          raise ArgumentError, "expected argument to be a Hash"
        end

        result = {}

        result
      end
    end
  end
end
