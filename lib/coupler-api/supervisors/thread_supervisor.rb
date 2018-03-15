module CouplerAPI
  class ThreadSupervisor < Supervisor
    def initialize(runner, job_repo)
      @runner = runner
      super(job_repo)
    end

    def self.dependencies
      ['Runner', 'JobRepository']
    end

    def run_job(job)
      Thread.new do
        puts "Running job #{job.id}..."
        @runner.run(job.id)
      end
    end
  end
end
