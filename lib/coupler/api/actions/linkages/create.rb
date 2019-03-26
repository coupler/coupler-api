module Coupler::API
  module Linkages
    class Create
      def initialize(repo, validator)
        @repo = repo
        @validator = validator
      end

      def self.dependencies
        ['LinkageRepository', 'LinkageValidators::Create']
      end

      def run(params)
        errors = @validator.validate(params)
        if errors.empty?
          linkage = @repo.save(Linkage.new(params))
          { 'id' => linkage.id }
        else
          { 'errors' => errors }
        end
      end
    end
  end
end
