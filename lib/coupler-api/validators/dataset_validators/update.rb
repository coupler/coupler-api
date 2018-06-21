module CouplerAPI
  module DatasetValidators
    class Update
      def self.dependencies
        []
      end

      def validate(data, dataset)
        if !data.is_a?(Hash)
          raise ArgumentError, "expected argument to be a Hash"
        end
        errors = []

        if data[:id].nil?
          errors.push("id must be present")
        elsif !data[:id].is_a?(Integer)
          errors.push("id must be a number")
        end

        if data.has_key?(:name) && data[:name].empty?
          errors.push("name cannot be empty")
        end

        if dataset
          case dataset.type
          when "mysql"
            if data.has_key?(:host) && data[:host].empty?
              errors.push("host cannot be empty")
            end

            if data.has_key?(:database_name) && data[:database_name].empty?
              errors.push("database_name cannot be empty")
            end

            if data.has_key?(:username) && data[:username].empty?
              errors.push("username cannot be empty")
            end

            if data.has_key?(:table_name) && data[:table_name].empty?
              errors.push("table_name cannot be empty")
            end
          when "sqlite3"
            if data.has_key?(:table_name) && data[:table_name].empty?
              errors.push("table_name cannot be empty")
            end
          end
        end

        errors
      end
    end
  end
end
