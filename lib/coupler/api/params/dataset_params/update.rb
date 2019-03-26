module Coupler::API
  module DatasetParams
    class Update < Base
      def self.valid_keys
        @@valid_keys ||= %w{name host database_name username password table_name}
      end

      def process(data)
        if !data.is_a?(Hash)
          raise ArgumentError, "expected argument to be a Hash"
        end
        result = {}

        if data.has_key?('id')
          result[:id] = data['id']
        end

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
