module CouplerAPI
  class LinkageCombiner
    def self.dependencies
      ['LinkageRepository', 'DatasetRepository', 'ComparatorRepository', 'JobRepository']
    end

    def initialize(linkage_repo, dataset_repo, comparator_repo, job_repo)
      @linkage_repo = linkage_repo
      @dataset_repo = dataset_repo
      @comparator_repo = comparator_repo
      @job_repo = job_repo
    end

    def find(id)
      linkage = @linkage_repo.first({ :id => id })
      if linkage.nil?
        return nil
      end

      dataset_1 = @dataset_repo.first({ :id => linkage.dataset_1_id })
      if linkage.dataset_1_id == linkage.dataset_2_id
        dataset_2 = dataset_1
      else
        dataset_2 = @dataset_repo.first({ :id => linkage.dataset_2_id })
      end

      comparators = @comparator_repo.find({ :linkage_id => id})
      jobs = @job_repo.find({ :linkage_id => id})

      linkage.dataset_1 = dataset_1
      linkage.dataset_2 = dataset_2
      linkage.comparators = comparators
      linkage.jobs = jobs

      linkage
    end
  end
end
