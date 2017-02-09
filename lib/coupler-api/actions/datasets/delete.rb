module CouplerAPI
  module Datasets
    class Delete
      def initialize(repo, validator)
        @repo = repo
        @validator = validator
      end

      def self.dependencies
        ['DatasetRepository', 'DatasetValidators::Show']
      end

      def run(params)
        errors = @validator.validate(params)
        if !errors.empty?
          return { 'errors' => errors }
        end

        dataset = @repo.first(id: params[:id])
        if dataset.nil?
          return { 'errors' => { 'id' => ['was not found'] } }
        end

        @repo.delete(dataset)
        { 'id' => dataset.id }
      end
    end
  end
end
