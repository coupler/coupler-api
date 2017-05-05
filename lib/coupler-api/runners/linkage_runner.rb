module CouplerAPI
  class LinkageRunner
    def initialize(linkage_combiner, job_repo, linkage_result_repo, storage_path)
      @linkage_combiner = linkage_combiner
      @job_repo = job_repo
      @linkage_result_repo = linkage_result_repo
      @storage_path = storage_path
    end

    def self.dependencies
      [ 'LinkageCombiner', 'JobRepository', 'LinkageResultRepository', 'storage_path' ]
    end

    def run(job)
      job.status = "running"
      job.started_at = Time.now
      @job_repo.save(job)

      linkage = @linkage_combiner.find(id: job.linkage_id)
      if linkage.nil?
        job.status = "failed"
        job.ended_at = Time.now
        job.error = "linkage not found"
        @job_repo.save(job)

        return { 'errors' => ['linkage not found'] }
      end
      dataset_1 = linkage.dataset_1
      dataset_2 = linkage.dataset_2
      comparators = linkage.comparators

      # create linkage result
      linkage_result = LinkageResult.new({
        job_id: job.id, linkage_id: linkage.id
      })
      @linkage_result_repo.save(linkage_result)
      job.linkage_result_id = linkage_result.id

      linkage_result.database_path =
        File.join(@storage_path, "linkage-result-#{linkage_result.id}.sqlite")
      @linkage_result_repo.save(linkage_result)

      result_set = ::Linkage::ResultSet['database'].new(linkage_result.uri)

      # create linkage datasets
      dataset_1 = ::Linkage::Dataset.new(dataset_1.uri, dataset_1.table_name)
      if dataset_2
        dataset_2 = ::Linkage::Dataset.new(dataset_2.uri, dataset_2.table_name)
      end

      # create configuration
      config =
        if dataset_2
          ::Linkage::Configuration.new(dataset_1, dataset_2, result_set)
        else
          ::Linkage::Configuration.new(dataset_1, result_set)
        end

      # add comparators
      comparators.each do |comparator|
        case comparator.kind
        when 'compare'
          operation = comparator.options['operation'].to_sym
          config.compare(comparator.set_1, comparator.set_2, operation)
        when 'strcompare'
          field_1 = comparator.set_1[0]
          field_2 = comparator.set_2[0]
          operation = comparator.options['operation'].to_sym
          config.strcompare(field_1, field_2, operation)
        when 'within'
          field_1 = comparator.set_1[0]
          field_2 = comparator.set_2[0]
          config.within(field_1, field_2, comparator.options['value'])
        end
      end

      begin
        # run linkage
        runner = ::Linkage::Runner.new(config)
        runner.execute

        job.status = "finished"
        job.ended_at = Time.now
        @job_repo.save(job)

        # save result summary
        linkage_result.calculate_match_count!
        @linkage_result_repo.save(linkage_result_repo)

        { 'success' => true }
      rescue Exception => e
        job.status = "failed"
        job.ended_at = Time.now
        job.error = e.to_s
        @job_repo.save(job)

        { 'errors' => [e.to_s] }
      end
    end
  end
end
