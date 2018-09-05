module CouplerAPI
  module CsvImports
    class Download
      def initialize(repo, validator)
        @repo = repo
        @validator = validator
      end

      def self.dependencies
        ['CsvImportRepository', 'CsvImportValidators::Download']
      end

      def run(params)
        errors = @validator.validate(params)
        if errors.empty?
          csv_import = @repo.first(id: params[:id])
          if csv_import.nil?
            { 'errors' => 'not found' }
          else
            {
              '_download' => {
                'path' => csv_import.file_path,
                'filename' => csv_import.original_name,
                'content_type' => 'text/csv'
              }
            }
          end
        else
          { 'errors' => errors }
        end
      end
    end
  end
end
