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
        if params[:id]
          dataset = @repo.first(id: params[:id])
          if dataset.nil?
            return { 'errors' => ['id was not found'] }
          end
        else
          dataset = nil
        end

        errors = @validator.validate(params, dataset)
        if !errors.empty?
          return { 'errors' => errors }
        end

        dataset.update(params)
        # check for connectivity
        dataset = Dataset.new(params)
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
