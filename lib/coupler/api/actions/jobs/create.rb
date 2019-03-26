module Coupler::API
  module Jobs
    class Create
      def initialize(repo, validator)
        @repo = repo
        @validator = validator
      end

      def self.dependencies
        ['JobRepository', 'JobValidators::Create']
      end

      def run(params)
        errors = @validator.validate(params)
        if errors.empty?
          job = Job.new(params)
          job.status = "initialized"
          job = @repo.save(job)
          { 'id' => job.id }
        else
          { 'errors' => errors }
        end
      end
    end
  end
end
