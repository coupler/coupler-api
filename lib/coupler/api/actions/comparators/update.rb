module Coupler::API
  module Comparators
    class Update
      def initialize(repo, validator)
        @repo = repo
        @validator = validator
      end

      def self.dependencies
        ['ComparatorRepository', 'ComparatorValidators::Update']
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

        comparator.update(params)
        @repo.save(comparator)
        { 'id' => comparator.id }
      end
    end
  end
end
