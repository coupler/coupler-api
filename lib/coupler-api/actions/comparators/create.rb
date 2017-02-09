module CouplerAPI
  module Comparators
    class Create
      def initialize(repo, validator)
        @repo = repo
        @validator = validator
      end

      def self.dependencies
        ['ComparatorRepository', 'ComparatorValidators::Create']
      end

      def run(params)
        errors = @validator.validate(params)
        if errors.empty?
          comparator = @repo.create(params)
          { 'id' => comparator.id }
        else
          { 'errors' => errors }
        end
      end
    end
  end
end