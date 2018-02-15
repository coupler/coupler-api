module CouplerAPI
  class Background
    def initialize(storage_path, database_uri, script_name, job_repo)
      @storage_path = storage_path
      @database_uri = database_uri
      @script_name = script_name
      @job_repo = job_repo

      @running = false
      @main_thread = nil
      @processes = []
    end

    def self.dependencies
      ['storage_path', 'database_uri', 'script_name', 'JobRepository']
    end

    def start
      @main_thread = Thread.new do
        @running = true
        while @running
          jobs = @job_repo.find(status: 'initialized')
          jobs.each do |job|
            run_job(job)
          end

          # clean up finished processes
          @processes.select! { |t| t.alive? }

          sleep 5
        end
      end
    end

    def run_job(job)
      thread = Thread.new do
        pid = spawn(RbConfig.ruby, @script_name, "job", "--storage-path",
                    @storage_path, "--database-uri", @database_uri, job.id.to_s)
        Process.wait(pid)
      end
      @processes << thread
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
