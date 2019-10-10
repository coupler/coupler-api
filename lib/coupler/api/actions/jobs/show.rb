module Coupler::API
  module Jobs
    class Show
      def initialize(repo, validator)
        @repo = repo
        @validator = validator
      end

      def self.dependencies
        ['JobRepository', 'JobValidators::Show']
      end

      def run(params)
        errors = @validator.validate(params)
        if errors.empty?
          job = @repo.first(params)
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
