module Coupler::API
  class Runner
    def initialize(job_repo, linkage_runner, migration_runner,
                   linkage_result_export_runner, dataset_export_runner)

      @job_repo = job_repo
      @linkage_runner = linkage_runner
      @migration_runner = migration_runner
      @linkage_result_export_runner = linkage_result_export_runner
      @dataset_export_runner = dataset_export_runner
    end

    def self.dependencies
      ['JobRepository', 'LinkageRunner', 'MigrationRunner',
       'LinkageResultExportRunner', 'DatasetExportRunner']
    end

    def run(job_id)
      job = @job_repo.first(:id => job_id)
      raise "Job #{job_id} not found" if job.nil?

      runner =
        case job.kind
        when 'linkage'
          @linkage_runner
        when 'migration'
          @migration_runner
        when 'linkage_result_export'
          @linkage_result_export_runner
        when 'dataset_export'
          @dataset_export_runner
        end

      if runner.nil?
        raise "couldn't find runner for job of type #{job.kind.inspect}"
      end

      runner.run(job)
    end
  end
end
