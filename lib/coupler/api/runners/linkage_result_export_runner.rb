module Coupler::API
  class LinkageResultExportRunner
    def initialize(lr_combiner, job_repo, dataset_repo, storage_path)
      @lr_combiner = lr_combiner
      @job_repo = job_repo
      @dataset_repo = dataset_repo
      @storage_path = storage_path
    end

    def self.dependencies
      [ 'LinkageResultCombiner', 'JobRepository', 'DatasetRepository', 'storage_path' ]
    end

    def run(job)
      job.status = "running"
      job.started_at = Time.now
      @job_repo.save(job)

      linkage_result = @lr_combiner.find(id: job.linkage_result_id)
      if linkage_result.nil?
        job.status = "failed"
        job.ended_at = Time.now
        job.error = "linkage_result not found"
        @job_repo.save(job)

        return { 'errors' => ['linkage_result not found'] }
      end

      # setup output dataset
      output_dataset = Dataset.new({
        linkage_result_id: linkage_result.id, type: 'sqlite3',
        database_path: File.join(@storage_path, "linkage-result-export-#{job.id}.sqlite"),
        table_name: 'linkage_result_export', pending: true
      })
      @dataset_repo.save(output_dataset)

      job.dataset_id = output_dataset.id
      @job_repo.save(job)

      # setup ethel migration
      linkage = linkage_result.linkage
      dataset_1 = linkage.dataset_1
      dataset_2 = linkage.dataset_2
      puts "Reader URI: #{dataset_1.uri}"
      reader = ::Ethel::Reader['sequel'].new({
        connect_options: dataset_1.uri,
        table_name: dataset_1.table_name
      })
      puts "Writer URI: #{output_dataset.uri}"
      writer = ::Ethel::Writer['sequel'].new({
        connect_options: output_dataset.uri,
        table_name: output_dataset.table_name
      })
      migration = ::Ethel::Migration.new(reader, writer)

      # create join operation
      puts "Target URI: #{dataset_2.uri}"
      target_reader = ::Ethel::Reader['sequel'].new({
        connect_options: dataset_2.uri,
        table_name: dataset_2.table_name
      })
      puts "Join URI: #{linkage_result.uri}"
      join_reader = ::Ethel::Reader['sequel'].new({
        connect_options: linkage_result.uri,
        table_name: "matches"
      })
      op = ::Ethel::Operation['join'].new(target_reader, join_reader, {
        origin_fields: { name: dataset_1.primary_key['name'], alias: 'id_1' },
        target_fields: { name: dataset_2.primary_key['name'], alias: 'id_2' },
      })
      migration.add_operation(op)

      begin
        # run migration
        migration.run

        job.status = "finished"
        job.ended_at = Time.now
        @job_repo.save(job)

        output_dataset.pending = false
        @dataset_repo.save(output_dataset)

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
