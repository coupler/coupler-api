module Coupler::API
  class MigrationCombiner
    def initialize(migration_repo, dataset_repo)
      @migration_repo = migration_repo
      @dataset_repo = dataset_repo
    end

    def self.dependencies
      ['MigrationRepository', 'DatasetRepository']
    end

    def find(conditions)
      migration = @migration_repo.first(conditions)
      if migration.nil?
        return nil
      end

      if migration.input_dataset_id
        migration.input_dataset = @dataset_repo.first({ :id => migration.input_dataset_id })
      end

      if migration.output_dataset_id
        migration.output_dataset = @dataset_repo.first({ :id => migration.output_dataset_id })
      end

      migration
    end
  end
end
