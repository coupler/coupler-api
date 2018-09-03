module CouplerAPI
  module Migrations
    class Show
      def initialize(repo, validator)
        @repo = repo
        @validator = validator
      end

      def self.dependencies
        ['MigrationRepository', 'MigrationValidators::Show']
      end

      def run(params)
        errors = @validator.validate(params)
        if errors.empty?
          migration = @repo.first(id: params[:id])
          if migration.nil?
            { 'errors' => 'not found' }
          else
            migration.to_h
          end
        else
          { 'errors' => errors }
        end
      end
    end
  end
end
