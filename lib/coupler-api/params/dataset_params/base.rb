module CouplerAPI
  module DatasetParams
    class Base
      def self.dependencies
        []
      end

      def self.valid_keys
        @@valid_keys ||= %w{name type host database_name username password table_name}
      end

      def process(data)
        if !data.is_a?(Hash)
          raise ArgumentError, "expected argument to be a Hash"
        end

        result = {}
        self.class.valid_keys.each do |key|
          if data.include?(key)
            result[key.to_sym] = data[key]
          end
        end
        result
      end
    end
  end
end
