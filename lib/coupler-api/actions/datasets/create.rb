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
        if !errors.empty?
          return { 'errors' => errors }
        end

        # check for connectivity
        dataset = Dataset.new(params)
        if dataset.can_connect?
          @repo.save(dataset)
          { 'id' => dataset.id }
        else
          { 'errors' => { 'base' => ["can't connect"] } }
        end
      end
    end
  end
end
