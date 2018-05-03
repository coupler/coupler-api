module CouplerAPI
  module CsvImports
    class Create
      def initialize(repo, validator, importer, storage_path)
        @repo = repo
        @validator = validator
        @importer = importer
        @storage_path = storage_path
      end

      def self.dependencies
        [
          'CsvImportRepository', 'CsvImportValidators::Create', 'CSVImporter',
          'storage_path'
        ]
      end

      def run(params)
        errors = @validator.validate(params)
        if !errors.empty?
          return { 'errors' => errors }
        end

        begin
          fields = @importer.detect_fields(params[:data])
        rescue CSVImporter::MalformedCSVError => e
          return { 'errors' => [ e.msg ] }
        end

        digest = Digest::SHA1.hexdigest(params[:data])
        file_path = File.join(@storage_path, digest + ".csv")
        if !File.exist?(file_path)
          File.open(file_path, 'wb') { |f| f.write(params[:data]) }
        end
        csv_import = CsvImport.new({
          original_name: params[:filename],
          file_path: file_path,
          file_size: File.size(file_path),
          detected_fields: fields,
          created_at: Time.now
        })
        @repo.save(csv_import)
        { 'id' => csv_import.id, 'detected_fields' => fields }
      end
    end
  end
end
