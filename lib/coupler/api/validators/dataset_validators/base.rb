module Coupler::API
  module DatasetValidators
    class Base
      def self.dependencies
        []
      end

      def self.valid_types
        # csv is only valid on create
        @@valid_types ||= %w{mysql sqlite3}
      end

      def valid_types
        self.class.valid_types
      end

      def validate(data)
        if !data.is_a?(Hash)
          raise ArgumentError, "expected argument to be a Hash"
        end
        errors = []

        if data[:name].nil? || data[:name].empty?
          errors.push("name must be present")
        end

        if !valid_types.include?(data[:type])
          errors.push("type must be one of the following: #{valid_types.inspect}")
        else
          case data[:type]
          when "mysql"
            if data[:host].nil? || data[:host].empty?
              errors.push("host must be present")
            end

            if data[:database_name].nil? || data[:database_name].empty?
              errors.push("database_name must be present")
            end

            if data[:username].nil? || data[:username].empty?
              errors.push("username must be present")
            end

            if data[:table_name].nil? || data[:table_name].empty?
              errors.push("table_name must be present")
            end
          when "sqlite3"
            if data[:database_path].nil? || data[:database_path].empty?
              errors.push("database_path must be present")
            end

            if data[:table_name].nil? || data[:table_name].empty?
              errors.push("table_name must be present")
            end
          end
        end

        errors
      end
    end
  end
end
