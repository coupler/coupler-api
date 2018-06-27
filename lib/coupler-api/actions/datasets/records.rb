module CouplerAPI
  module Datasets
    class Records
      def initialize(repo, validator)
        @repo = repo
        @validator = validator
      end

      def self.dependencies
        ['DatasetRepository', 'DatasetValidators::Records']
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

        dataset.fetch_records(nil, params[:limit], params[:offset])
      end
    end
  end
end
