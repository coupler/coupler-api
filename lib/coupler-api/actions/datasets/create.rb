module CouplerAPI
  module Datasets
    class Create
      def initialize(repo, validator)
        @repo = repo
        @validator = validator
      end

      def self.dependencies
        ['DatasetRepository', 'DatasetValidators::Create']
      end

      def run(params)
        errors = @validator.validate(params)
        if errors.empty?
          dataset = @repo.create(params)
          { 'id' => dataset.id }
        else
          { 'errors' => errors }
        end
      end
    end
  end
end
