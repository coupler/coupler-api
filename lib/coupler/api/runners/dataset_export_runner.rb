module Coupler::API
  class DatasetExportRunner
    def initialize(job_repo, dataset_repo, storage_path)
      @job_repo = job_repo
      @dataset_repo = dataset_repo
      @storage_path = storage_path
    end

    def self.dependencies
      [ 'JobRepository', 'DatasetRepository', 'storage_path' ]
    end

    def run(job)
      job.status = "running"
      job.started_at = Time.now
      @job_repo.save(job)

      input_dataset = @dataset_repo.first(id: job.dataset_id)
      if input_dataset.nil?
        job.status = "failed"
        job.ended_at = Time.now
        job.error = "dataset not found"
        @job_repo.save(job)

        return { 'errors' => ['dataset not found'] }
      end

      reader = ::Ethel::Reader['sequel'].new({
        connect_options: input_dataset.uri,
        table_name: input_dataset.table_name
      })

      slug = input_dataset.name.gsub(/\W+/, '-')
      output_path = File.join(@storage_path, "#{slug}_#{Date.today}")
      case job.dataset_export_kind
      when 'sqlite3'
        output_path += '.sqlite3'
        writer_type = 'sequel'
        connect_options =
          if RUBY_PLATFORM == "java"
            "jdbc:sqlite:#{output_path}"
          else
            "sqlite://#{output_path}"
          end
        writer_opts = {
          connect_options: connect_options,
          table_name: input_dataset.table_name
        }
      when 'csv'
        output_path += '.csv'
        writer_type = 'csv'
        writer_opts = { file: output_path }
      else
        raise "invalid dataset export kind: #{job.dataset_export_kind}"
      end
      writer = ::Ethel::Writer[writer_type].new(writer_opts)
      m = ::Ethel::Migration.new(reader, writer)

      begin
        # run migration
        m.run

        job.status = "finished"
        job.ended_at = Time.now
        job.dataset_export_path = output_path
        @job_repo.save(job)

        { 'success' => true }
      rescue Exception => e
        p e
        puts e.backtrace.join("\n")
        job.status = "failed"
        job.ended_at = Time.now
        job.error = e.to_s
        @job_repo.save(job)

        { 'errors' => [e.to_s] }
      end
    end
  end
end
