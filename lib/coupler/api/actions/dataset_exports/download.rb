module Coupler::API
  module DatasetExports
    class Download
      def initialize(repo, validator)
        @repo = repo
        @validator = validator
      end

      def self.dependencies
        ['DatasetExportRepository', 'DatasetExportValidators::Download']
      end

      def run(params)
        errors = @validator.validate(params)
        if errors.empty?
          dataset_export = @repo.first(id: params[:id])
          if dataset_export.nil?
            { 'errors' => 'not found' }
          else
            content_type =
              case dataset_export.kind
              when 'sqlite3'
                'application/x-sqlite3'
              when 'csv'
                'text/csv'
              else
                'application/octet-stream'
              end
            {
              '_download' => {
                'path' => dataset_export.path,
                'filename' => File.basename(dataset_export.path),
                'content_type' => content_type
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
