module Coupler::API
  module DatasetValidators
    class Create < Base
      def self.dependencies
        []
      end

      def self.valid_types
        @@valid_types ||= super() + %w{csv}
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
        end

        errors
      end
    end
  end
end
