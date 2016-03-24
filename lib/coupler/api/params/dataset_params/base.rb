module Coupler
  module API
    module DatasetParams
      class Base
        VALID_TYPES = %w{csv mysql}

        def self.process(data)
          if !data.is_a?(Hash)
            raise ArgumentError, "expected argument to be a Hash"
          end

          data.select do |key, value|
            %w{name type host database_name username password table_name csv}.include?(key)
          end
        end

        def self.validate(data)
          if !data.is_a?(Hash)
            raise ArgumentError, "expected argument to be a Hash"
          end
          errors = []

          if data["name"].nil? || data["name"].empty?
            errors.push("name must be present")
          end

          if !VALID_TYPES.include?(data["type"])
            errors.push("type must be one of the following: #{VALID_TYPES.inspect}")
          else
            case data["type"]
            when "mysql"
              if data["host"].nil? || data["host"].empty?
                errors.push("host must be present")
              end

              if data["database_name"].nil? || data["database_name"].empty?
                errors.push("database_name must be present")
              end

              if data["username"].nil? || data["username"].empty?
                errors.push("username must be present")
              end

              if data["table_name"].nil? || data["table_name"].empty?
                errors.push("table_name must be present")
              end

              if !data["csv"].nil? && !data["csv"].empty?
                errors.push("csv must not be present")
              end
            when "csv"
              if !data["host"].nil? && !data["host"].empty?
                errors.push("host must not be present")
              end

              if !data["database_name"].nil? && !data["database_name"].empty?
                errors.push("database_name must not be present")
              end

              if !data["username"].nil? && !data["username"].empty?
                errors.push("username must not be present")
              end

              if !data["table_name"].nil? && !data["table_name"].empty?
                errors.push("table_name must not be present")
              end

              if data["csv"].nil? || data["csv"].empty?
                errors.push("csv must be present")
              end
            end
          end

          errors
        end
      end
    end
  end
end
