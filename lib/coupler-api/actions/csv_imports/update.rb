module CouplerAPI
  module CsvImports
    class Update
      def initialize(repo, validator)
        @repo = repo
        @validator = validator
      end

      def self.dependencies
        [ 'CsvImportRepository', 'CsvImportValidators::Update' ]
      end

      def run(params)
        errors = @validator.validate(params)
        if !errors.empty?
          return { 'errors' => errors }
        end

        csv_import = @repo.first(id: params[:id])
        if csv_import.nil?
          return { 'errors' => ['id was not found'] }
        end

        csv_import.update(params)
        @repo.save(csv_import)
        { 'id' => csv_import.id }
      end
    end
  end
end
