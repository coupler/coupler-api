module CouplerAPI
  module Jobs
    class Linkage
      def initialize(job_repo, linkage_repo, comparator_repo, dataset_repo, storage_path)
        @job_repo = job_repo
        @linkage_repo = linkage_repo
        @comparator_repo = comparator_repo
        @dataset_repo = dataset_repo
        @storage_path = storage_path
      end

      def self.dependencies
        ['JobRepository', 'LinkageRepository', 'ComparatorRepository', 'DatasetRepository', 'storage_path']
      end

      def run(params)
        errors = JobParams::Linkage.validate(params)
        if !errors.empty?
          return { 'errors' => errors }
        end

        job = @job_repo.first(params)
        if job.nil?
          return { 'errors' => 'job not found' }
        elsif job.kind != 'linkage'
          return { 'errors' => 'job is invalid' }
        end

        linkage = @linkage_repo.first(:id => job.linkage_id)
        if linkage.nil?
          return { 'errors' => 'linkage not found' }
        end

        dataset_1 = @dataset_repo.first(:id => linkage.dataset_1_id)
        if dataset_1.nil?
          return { 'errors' => 'dataset_1 not found' }
        end

        if linkage.dataset_1_id != linkage.dataset_2_id
          dataset_2 = @dataset_repo.first(:id => linkage.dataset_2_id)
          if dataset_2.nil?
            return { 'errors' => 'dataset_2 not found' }
          end
        end

        comparators = @comparator_repo.find(:linkage_id => linkage.id)
        if comparators.empty?
          return { 'errors' => 'comparators not found' }
        end

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

        # run linkage
        runner = ::Linkage::Runner.new(config)
        runner.execute

        { 'success' => true }
      end
    end
  end
end
