module CouplerAPI
  module Jobs
    class Run
      def initialize(validator, job_repo, runner)
        @validator = validator
        @job_repo = job_repo
        @runner = runner
      end

      def self.dependencies
        [ 'JobValidators::Run', 'JobRepository', 'Runner' ]
      end

      def run(params)
        errors = @validator.validate(params)
        if !errors.empty?
          return { 'errors' => errors }
        end

        job = @job_repo.first(params)
        if job.nil?
          return { 'errors' => 'job not found' }
        elsif job.status != 'initialized'
          return { 'errors' => 'job has already been started' }
        end

        @runner.run(job)
      end
    end
  end
end
