module Coupler::API
  class DatasetExportRunner
    def initialize(job_repo, dataset_repo, dataset_export_repo, storage_path)
      @job_repo = job_repo
      @dataset_repo = dataset_repo
      @dataset_export_repo = dataset_export_repo
      @storage_path = storage_path
    end

    def self.dependencies
      [ 'JobRepository', 'DatasetRepository', 'DatasetExportRepository',
        'storage_path' ]
    end

    def run(job)
      job.status = "running"
      job.started_at = Time.now
      @job_repo.save(job)

      # find input dataset
      input_dataset = @dataset_repo.first(id: job.dataset_id)
      if input_dataset.nil?
        job.status = "failed"
        job.ended_at = Time.now
        job.error = "dataset not found"
        @job_repo.save(job)

        return { 'errors' => ['dataset not found'] }
      end

      # setup ethel reader
      reader = ::Ethel::Reader['sequel'].new({
        connect_options: input_dataset.uri,
        table_name: input_dataset.table_name
      })

      # determine output path
      export_kind = job.dataset_export_kind
      slug = input_dataset.name.gsub(/\W+/, '-')
      output_path = File.join(@storage_path, "#{slug}_#{Date.today}.#{export_kind}")
      output_path_index = 1
      while File.exist?(output_path)
        output_path_index += 1
        output_path = File.join(@storage_path, "#{slug}_#{Date.today}_#{output_path_index}.#{export_kind}")
      end

      # setup ethel writer
      case export_kind
      when 'sqlite3'
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
        writer_type = 'csv'
        writer_opts = { file: output_path }
      else
        raise "invalid dataset export kind: #{export_kind}"
      end
      writer = ::Ethel::Writer[writer_type].new(writer_opts)

      m = ::Ethel::Migration.new(reader, writer)
      begin
        # run migration
        m.run

        dataset_export = DatasetExport.new({
          dataset_id: input_dataset.id, job_id: job.id,
          kind: export_kind, path: output_path, pending: false
        })
        @dataset_export_repo.save(dataset_export)

        job.dataset_export_id = dataset_export.id
        job.status = "finished"
        job.ended_at = Time.now
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
