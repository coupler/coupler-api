module Coupler::API
  module DatasetValidators
    class Update < Base
      def validate(data)
        errors = super(data)

        if data[:id].nil?
          errors.push("id must be present")
          return errors
        end

        if !data[:id].is_a?(Integer)
          errors.push("id must be a number")
          return errors
        end

        dataset = @dataset_repo.first(id: data[:id])
        if dataset.nil?
          errors.push("id is not valid")
          return errors
        end

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

        errors
      end
    end
  end
end
