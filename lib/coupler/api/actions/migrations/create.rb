module Coupler::API
  module Migrations
    class Create
      def initialize(validator, migration_repo, dataset_repo)
        @validator = validator
        @migration_repo = migration_repo
        @dataset_repo = dataset_repo
      end

      def self.dependencies
        ['MigrationValidators::Create', 'MigrationRepository', 'DatasetRepository']
      end

      def run(params)
        errors = @validator.validate(params)
        if errors.empty?
          # validate output dataset
          output_dataset_params = params.delete(:output_dataset)
          output_dataset_params[:pending] = true
          output_dataset = Dataset.new(output_dataset_params)

          if !output_dataset.can_connect?
            return { 'errors' => ["can't connect to output database"] }
          end
          if output_dataset.table_exists?
            return { 'errors' => ["output table name already exists"] }
          end

          # save migration first
          migration = Migration.new(params)
          migration = @migration_repo.save(migration)

          # save output dataset
          output_dataset.migration_id = migration.id
          output_dataset = @dataset_repo.save(output_dataset)

          # add output dataset id to migration
          migration.output_dataset_id = output_dataset.id
          migration = @migration_repo.save(migration)

          { 'id' => migration.id }
        else
          { 'errors' => errors }
        end
      end
    end
  end
end
