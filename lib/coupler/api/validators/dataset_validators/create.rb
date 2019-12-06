module Coupler::API
  module DatasetValidators
    class Create < Base
      VALID_TYPES = %w{mysql sqlite3 csv}

      def validate(data)
        errors = super(data)

        if !VALID_TYPES.include?(data[:type])
          errors.push("type must be one of the following: #{VALID_TYPES.inspect}")
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
          when "csv"
            if data[:csv_import_id].nil?
              errors.push("csv_import_id must be present")
            elsif !data[:csv_import_id].is_a?(Integer)
              errors.push("csv_import_id is not valid")
            end
          end
        end

        errors
      end
    end
  end
end
