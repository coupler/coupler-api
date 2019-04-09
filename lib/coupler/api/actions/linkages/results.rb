module Coupler::API
  module Linkages
    class Results
      def initialize(combiner, validator)
        @combiner = combiner
        @validator = validator
      end

      def self.dependencies
        ['LinkageResultCombiner', 'LinkageValidators::Show']
      end

      def run(params)
        errors = @validator.validate(params)
        if errors.empty?
          conditions = { :linkage_id => params[:id] }
          @combiner.find_all(conditions).collect(&:to_h)
        else
          { 'errors' => errors }
        end
      end
    end
  end
end
