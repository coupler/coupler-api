module Coupler::API
  module JobParams
    class Base
      def self.dependencies
        []
      end

      def self.valid_keys
        @valid_keys ||= %w{
          kind linkage_id migration_id linkage_result_id dataset_id
          dataset_export_kind
        }
      end

      def valid_keys
        self.class.valid_keys
      end

      def process(data)
        if !data.is_a?(Hash)
          raise ArgumentError, "expected argument to be a Hash"
        end

        result = {}
        data.each_pair do |key, value|
          if valid_keys.include?(key)
            result[key.to_sym] = value
          end
        end
        result
      end
    end
  end
end
