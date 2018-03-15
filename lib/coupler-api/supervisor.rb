module CouplerAPI
  class Supervisor
    def initialize(job_repo)
      @job_repo = job_repo

      @running = false
      @main_thread = nil
      @processes = []
    end

    def start
      @main_thread = Thread.new do
        @running = true
        while @running
          jobs = @job_repo.find(status: 'initialized')
          jobs.each do |job|
            process = run_job(job)
            @processes.push(process)
          end

          # clean up finished processes
          @processes.select! { |t| t.alive? }

          sleep 5
        end
      end
    end

    def run_job(job)
      raise NotImplementedError
    end

    def stop
      @running = false
      if @main_thread
        @main_thread.join
        @main_thread = nil
      end
      @processes.each(&:join)
    end
  end
end
