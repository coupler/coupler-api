module Coupler::API
  module Linkages
    class Comparators
      def initialize(repo, validator)
        @repo = repo
        @validator = validator
      end

      def self.dependencies
        ['ComparatorRepository', 'LinkageValidators::Show']
      end

      def run(params)
        errors = @validator.validate(params)
        if errors.empty?
          conditions = { :linkage_id => params[:id] }
          @repo.find(conditions).collect(&:to_h)
        else
          { 'errors' => errors }
        end
      end
    end
  end
end
