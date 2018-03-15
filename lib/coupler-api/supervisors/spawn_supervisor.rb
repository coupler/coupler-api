module CouplerAPI
  class SpawnSupervisor < Supervisor
    def initialize(storage_path, database_uri, job_repo)
      @storage_path = storage_path
      @database_uri = database_uri
      super(job_repo)
    end

    def self.dependencies
      ['storage_path', 'database_uri', 'JobRepository']
    end

    def run_job(job)
      Thread.new do
        pid = spawn(RbConfig.ruby, "-S", "coupler-api", "job", "--storage-path",
                    @storage_path, "--database-uri", @database_uri, job.id.to_s)
        Process.wait(pid)
      end
    end
  end
end
