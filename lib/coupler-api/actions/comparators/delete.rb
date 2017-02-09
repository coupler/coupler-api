module CouplerAPI
  module Comparators
    class Delete
      def initialize(repo, validator)
        @repo = repo
        @validator = validator
      end

      def self.dependencies
        ['ComparatorRepository', 'ComparatorValidators::Show']
      end

      def run(params)
        errors = @validator.validate(params)
        if !errors.empty?
          return { 'errors' => errors }
        end

        comparator = @repo.first(id: params[:id])
        if comparator.nil?
          return { 'errors' => { 'id' => ['was not found'] } }
        end

        @repo.delete(comparator)
        { 'id' => comparator.id }
      end
    end
  end
end
