module CouplerAPI
  module MigrationParams
    class Create
      def self.dependencies
        []
      end

      def process(data)
        if !data.is_a?(Hash)
          raise ArgumentError, "expected argument to be a Hash"
        end

        result = {}
        data.each_pair do |key, value|
          if %w{description operations input_dataset_id output_dataset_id}.include?(key)
            result[key.to_sym] = value
          end
        end
        result
      end
    end
  end
end
