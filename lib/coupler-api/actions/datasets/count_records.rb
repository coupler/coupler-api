module CouplerAPI
  module Datasets
    class CountRecords
      def initialize(repo, validator)
        @repo = repo
        @validator = validator
      end

      def self.dependencies
        ['DatasetRepository', 'DatasetValidators::CountRecords']
      end

      def run(params)
        errors = @validator.validate(params)
        if !errors.empty?
          return { 'errors' => errors }
        end

        dataset = @repo.first(:id => params[:id])
        if dataset.nil?
          return { 'errors' => ['dataset not found'] }
        end

        dataset.count_records
      end
    end
  end
end
