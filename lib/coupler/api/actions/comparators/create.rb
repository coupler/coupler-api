module Coupler::API
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
          comparator = @repo.save(Comparator.new(params))
          { 'id' => comparator.id }
        else
          { 'errors' => errors }
        end
      end
    end
  end
end
