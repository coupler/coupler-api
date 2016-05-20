module CouplerAPI
  module Comparators
    class Show
      def initialize(repo, validator)
        @repo = repo
        @validator = validator
      end

      def self.dependencies
        ['ComparatorRepository', 'ComparatorValidators::Show']
      end

      def run(params)
        errors = @validator.validate(params)
        if errors.empty?
          comparator = @repo.first(params)
          if comparator.nil?
            { 'errors' => 'not found' }
          else
            comparator.to_h
          end
        else
          { 'errors' => errors }
        end
      end
    end
  end
end
