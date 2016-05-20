module CouplerAPI
  module LinkageParams
    class Base
      def self.dependencies
        []
      end

      def process(data)
        if !data.is_a?(Hash)
          raise ArgumentError, "expected argument to be a Hash"
        end

        result = {}
        data.each_pair do |key, value|
          if %w{name description dataset_1_id dataset_2_id}.include?(key)
            result[key.to_sym] = value
          end
        end
        result
      end
    end
  end
end
