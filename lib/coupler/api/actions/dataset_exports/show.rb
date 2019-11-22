module Coupler::API
  module DatasetExports
    class Show
      def initialize(repo, validator)
        @repo = repo
        @validator = validator
      end

      def self.dependencies
        ['DatasetExportRepository', 'DatasetExportValidators::Show']
      end

      def run(params)
        errors = @validator.validate(params)
        if errors.empty?
          dataset_export = @repo.first(id: params[:id])
          if dataset_export.nil?
            { 'errors' => 'not found' }
          else
            dataset_export.to_h
          end
        else
          { 'errors' => errors }
        end
      end
    end
  end
end
