module CouplerAPI
  class LinkageRunner
    def initialize(linkage_combiner, job_repo, storage_path)
      @linkage_combiner = linkage_combiner
      @job_repo = job_repo
      @storage_path = storage_path
    end

    def self.dependencies
      [ 'LinkageCombiner', 'JobRepository', 'storage_path' ]
    end

    def run(job)
      linkage = @linkage_combiner.find(id: job.linkage_id)
      if linkage.nil?
        return { 'errors' => 'linkage not found' }
      end
      dataset_1 = linkage.dataset_1
      dataset_2 = linkage.dataset_2
      comparators = linkage.comparators

      # create linkage result set
      db_path = File.join(@storage_path, "job-#{job.id}.sqlite")
      options =
        if RUBY_PLATFORM == "java"
          {
            :adapter => "jdbc",
            :uri => "jdbc:sqlite:#{db_path}"
          }
        else
          {
            :adapter => "sqlite",
            :database => db_path
          }
        end
      result_set = ::Linkage::ResultSet['database'].new(options)

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

      job.status = "running"
      job.started_at = Time.now
      @job_repo.save(job)

      # run linkage
      runner = ::Linkage::Runner.new(config)
      runner.execute

      job.status = "finished"
      job.ended_at = Time.now
      @job_repo.save(job)
    end
  end
end
