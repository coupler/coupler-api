module CouplerAPI
  module Linkages
    class Show
      def initialize(combiner, validator)
        @combiner = combiner
        @validator = validator
      end

      def self.dependencies
        ['LinkageCombiner', 'LinkageValidators::Show']
      end

      def run(params)
        errors = @validator.validate(params)
        if errors.empty?
          linkage = @combiner.find(params)
          if linkage.nil?
            { 'errors' => 'not found' }
          else
            linkage.to_h
          end
        else
          { 'errors' => errors }
        end
      end
    end
  end
end
