module CouplerAPI
  module DatasetValidators
    class Create < Base
      def self.dependencies
        []
      end

      def self.valid_types
        @@valid_types ||= super() + %w{csv}
      end

      def self.valid_field_kinds
        @@valid_field_kinds ||= %w{integer float text}
      end

      def valid_field_kinds
        self.class.valid_field_kinds
      end

      def validate(data)
        errors = super(data)

        # csv is only valid on create
        if data[:type] == "csv"
          if data[:csv_import_id].nil?
            errors.push("csv_import_id must be present")
          elsif !data[:csv_import_id].is_a?(Integer)
            errors.push("csv_import_id is not valid")
          end

          if data[:fields].nil? || data[:fields].empty?
            errors.push("fields must be present")
          elsif !data[:fields].is_a?(Array)
            errors.push("fields must be an array")
          elsif !data[:fields].all? { |x| x.is_a?(Hash) }
            errors.push("fields must be an array of hashes")
          else
            names = []
            primary_key = nil
            data[:fields].each_with_index do |field, i|
              unexpected = field.keys - %w{name kind primary_key}
              if !unexpected.empty?
                errors.push("fields[#{i}] contains unexpected keys: #{unexpected.join(',')}")
              end

              if field['name'].nil? || field['name'].empty?
                errors.push("fields[#{i}] must contain a name")
              elsif !field['name'].is_a?(String)
                errors.push("fields[#{i}] has an invalid name")
              elsif names.include?(field['name'])
                errors.push("fields[#{i}] has a duplicate name")
              else
                names.push(field['name'])
              end

              if field['kind'].nil? || field['kind'].empty?
                errors.push("fields[#{i}] must contain a kind")
              elsif !valid_field_kinds.include?(field['kind'])
                errors.push("fields[#{i}] has an invalid kind")
              end

              if field.has_key?('primary_key')
                if field['primary_key'] != true && field['primary_key'] != false
                  errors.push("fields[#{i}] has invalid primary key option")
                elsif field['primary_key']
                  if primary_key
                    errors.push("fields[#{i}] has duplicate primary key")
                  else
                    primary_key = field['name']
                  end
                end
              end
            end

            if primary_key.nil?
              errors.push("fields must contain a primary key field")
            end
          end
        end

        errors
      end
    end
  end
end
