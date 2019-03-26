module Coupler::API
  class LinkageCombiner
    def self.dependencies
      [
        'LinkageRepository', 'DatasetRepository', 'ComparatorRepository',
        'JobRepository', 'LinkageResultRepository'
      ]
    end

    def initialize(linkage_repo, dataset_repo, comparator_repo, job_repo, linkage_result_repo)
      @linkage_repo = linkage_repo
      @dataset_repo = dataset_repo
      @comparator_repo = comparator_repo
      @job_repo = job_repo
      @linkage_result_repo = linkage_result_repo
    end

    def find(conditions, which = :all)
      if which != :all && !which.is_a?(Array)
        raise "'which' must be :all or an array"
      end

      linkage = @linkage_repo.first(conditions)
      if linkage.nil?
        return nil
      end

      if which == :all || which.include?(:dataset_1)
        dataset_1 = @dataset_repo.first({ :id => linkage.dataset_1_id })
        linkage.dataset_1 = dataset_1
      end

      if which == :all || which.include?(:dataset_2)
        if linkage.dataset_1_id == linkage.dataset_2_id
          dataset_2 = dataset_1
        else
          dataset_2 = @dataset_repo.first({ :id => linkage.dataset_2_id })
        end
        linkage.dataset_2 = dataset_2
      end

      if which == :all || which.include?(:comparators)
        comparators = @comparator_repo.find({ :linkage_id => linkage.id })
        linkage.comparators = comparators
      end

      if which == :all || which.include?(:jobs)
        jobs = @job_repo.find({ :linkage_id => linkage.id })
        jobs.each do |job|
          if job.linkage_result_id
            job.linkage_result = @linkage_result_repo.first({ :id => job.linkage_result_id })
          end
        end
        linkage.jobs = jobs
      end

      linkage
    end
  end
end
