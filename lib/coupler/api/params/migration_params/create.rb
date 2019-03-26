module Coupler::API
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
          if %w{description operations input_dataset_id output_dataset}.include?(key)
            if key == "output_dataset"
              if value.is_a?(Hash)
                new_value = {}
                value.each_pair do |key_2, value_2|
                  if %w{name type host database_name username password table_name}.include?(key_2)
                    new_value[key_2.to_sym] = value_2
                  end
                end
                value = new_value
              end
            end

            result[key.to_sym] = value
          end
        end
        result
      end
    end
  end
end
