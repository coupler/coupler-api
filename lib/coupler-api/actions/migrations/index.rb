module CouplerAPI
  module Migrations
    class Index
      def initialize(repo, validator)
        @repo = repo
        @validator = validator
      end

      def self.dependencies
        ['MigrationRepository', 'MigrationValidators::Index']
      end

      def run(params)
        errors = @validator.validate(params)
        if errors.empty?
          @repo.find.collect(&:to_h)
        else
          { 'errors' => errors }
        end
      end
    end
  end
end
