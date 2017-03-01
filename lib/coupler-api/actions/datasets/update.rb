module CouplerAPI
  module Datasets
    class Update
      def initialize(repo, validator)
        @repo = repo
        @validator = validator
      end

      def self.dependencies
        ['DatasetRepository', 'DatasetValidators::Update']
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

        dataset.update(params)
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
