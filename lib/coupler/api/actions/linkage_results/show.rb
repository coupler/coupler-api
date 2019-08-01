module Coupler::API
  module LinkageResults
    class Show
      def initialize(combiner, validator)
        @combiner = combiner
        @validator = validator
      end

      def self.dependencies
        ['LinkageResultCombiner', 'LinkageResultValidators::Show']
      end

      def run(params)
        errors = @validator.validate(params)
        if errors.empty?
          linkage_result = @combiner.find(params)
          if linkage_result.nil?
            { 'errors' => ['not found'] }
          else
            linkage_result.to_h
          end
        else
          { 'errors' => errors }
        end
      end
    end
  end
end
