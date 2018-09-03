module CouplerAPI
  module Migrations
    class Create
      def initialize(repo, validator)
        @repo = repo
        @validator = validator
      end

      def self.dependencies
        ['MigrationRepository', 'MigrationValidators::Create']
      end

      def run(params)
        errors = @validator.validate(params)
        if errors.empty?
          migration = Migration.new(params)
          migration = @repo.save(migration)
          { 'id' => migration.id }
        else
          { 'errors' => errors }
        end
      end
    end
  end
end
