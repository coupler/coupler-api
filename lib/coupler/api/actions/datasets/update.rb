module Coupler::API
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
        dataset.update(params)

        # check for connectivity
        if dataset.table_exists?
          if dataset.has_primary_key?
            @repo.save(dataset)
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
