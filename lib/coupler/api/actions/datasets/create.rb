module Coupler::API
  module Datasets
    class Create
      def initialize(dataset_repo, validator, csv_import_repo, csv_importer)
        @dataset_repo = dataset_repo
        @validator = validator
        @csv_import_repo = csv_import_repo
        @csv_importer = csv_importer
      end

      def self.dependencies
        [
          'DatasetRepository', 'DatasetValidators::Create',
          'CsvImportRepository', 'CSVImporter'
        ]
      end

      def run(params)
        errors = @validator.validate(params)
        if !errors.empty?
          return { 'errors' => errors }
        end

        dataset = nil
        if params[:type] == "csv"
          csv_import = @csv_import_repo.first(id: params[:csv_import_id])
          if csv_import.nil?
            return { 'errors' => ["csv_import_id is invalid"] }
          end

          csv_filename = csv_import.file_path
          table_name = csv_import.generate_table_name
          fields = csv_import.fields
          begin
            database_path = @csv_importer.create_database(csv_filename, table_name, fields)
          rescue CSVImporter::DatabaseExistsError
            return { 'errors' => ["database already exists for specified csv import"] }
          end
          dataset = Dataset.new({
            name: params[:name], type: 'sqlite3', database_path: database_path,
            table_name: table_name, csv_import_id: csv_import.id
          })
        else
          dataset = Dataset.new(params)
        end

        # check for connectivity
        if dataset.table_exists?
          if dataset.has_primary_key?
            @dataset_repo.save(dataset)
            { 'id' => dataset.id }
          else
            { 'errors' => ["dataset has no primary key"] }
          end
        else
          { 'errors' => ["unable to connect"] }
        end
      end
    end
  end
end
