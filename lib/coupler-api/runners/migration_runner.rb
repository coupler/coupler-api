module CouplerAPI
  class MigrationRunner
    def initialize(job_repo, migration_combiner, dataset_repo)
      @job_repo = job_repo
      @migration_combiner = migration_combiner
      @dataset_repo = dataset_repo
    end

    def self.dependencies
      [ 'JobRepository', 'MigrationCombiner', 'DatasetRepository' ]
    end

    def run(job)
      job.status = "running"
      job.started_at = Time.now
      @job_repo.save(job)

      migration = @migration_combiner.find(id: job.migration_id)
      if migration.nil?
        job.status = "failed"
        job.ended_at = Time.now
        job.error = "migration not found"
        @job_repo.save(job)

        return { 'errors' => ['migration not found'] }
      end

      input_dataset = migration.input_dataset
      output_dataset = migration.output_dataset

      reader = ::Ethel::Reader['sequel'].new({
        connect_options: input_dataset.uri,
        table_name: input_dataset.table_name
      })
      writer = ::Ethel::Writer['sequel'].new({
        connect_options: output_dataset.uri,
        table_name: output_dataset.table_name
      })
      m = ::Ethel::Migration.new(reader, writer)

      # add operations
      migration.operations.each do |config|
        op =
          case config['name']
          when 'add_field'
            create_operation_add_field(config)
          when 'cast'
            create_operation_cast(config)
          when 'merge'
            create_operation_merge(config)
          when 'remove_field'
            create_operation_remove_field(config)
          when 'rename'
            create_operation_rename(config)
          when 'select'
            create_operation_select(config)
          else
            # this should only happen when someone manually edits the database
            raise "invalid operation: #{config.inspect}"
          end

        m.add_operation(op)
      end

      begin
        # run migration
        m.run

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

    private

    def create_operation_add_field(config)
      ::Ethel::Operation['add_field'].new(config['field_name'], config['type'].to_sym)
    end

    def create_operation_cast(config)
      ::Ethel::Operation['cast'].new(config['field_name'], config['new_type'].to_sym)
    end

    def create_operation_merge(config)
      if config['right_field_names']
        ::Ethel::Operation['merge'].new(config['left_field_names'], config['right_field_names'])
      else
        ::Ethel::Operation['merge'].new(config['left_field_names'])
      end
    end

    def create_operation_remove_field(config)
      ::Ethel::Operation['remove_field'].new(config['field_name'])
    end

    def create_operation_rename(config)
      ::Ethel::Operation['rename'].new(config['field_name'], config['new_field_name'])
    end

    def create_operation_select(config)
      ::Ethel::Operation['select'].new(config['field_names'])
    end
  end
end
