module Coupler::API
  module CsvImports
    class Show
      def initialize(repo, validator)
        @repo = repo
        @validator = validator
      end

      def self.dependencies
        ['CsvImportRepository', 'CsvImportValidators::Show']
      end

      def run(params)
        errors = @validator.validate(params)
        if errors.empty?
          csv_import = @repo.first(id: params[:id])
          if csv_import.nil?
            { 'errors' => 'not found' }
          else
            result = csv_import.to_sanitized_hash
            result['rows'] = csv_import.rows(params[:row_count] || 20)
            result
          end
        else
          { 'errors' => errors }
        end
      end
    end
  end
end
