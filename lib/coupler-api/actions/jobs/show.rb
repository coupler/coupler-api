module CouplerAPI
  module Jobs
    class Show
      def initialize(combiner, validator)
        @combiner = combiner
        @validator = validator
      end

      def self.dependencies
        ['JobCombiner', 'JobValidators::Show']
      end

      def run(params)
        errors = @validator.validate(params)
        if errors.empty?
          job = @combiner.find(params)
          if job.nil?
            { 'errors' => 'not found' }
          else
            job.to_h
          end
        else
          { 'errors' => errors }
        end
      end
    end
  end
end
