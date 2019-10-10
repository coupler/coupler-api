module Coupler::API
  class LinkageResultCombiner
    def initialize(linkage_result_repo, job_repo, linkage_repo, dataset_repo)
      @linkage_result_repo = linkage_result_repo
      @job_repo = job_repo
      @linkage_repo = linkage_repo
      @dataset_repo = dataset_repo
    end

    def self.dependencies
      ['LinkageResultRepository', 'JobRepository', 'LinkageRepository',
       'DatasetRepository']
    end

    def find_all(conditions)
      @linkage_result_repo.find(conditions).collect do |linkage_result|
        if linkage_result.job_id
          linkage_result.job = @job_repo.first({ :id => linkage_result.job_id })
        end
        linkage_result
      end
    end

    def find(conditions)
      linkage_result = @linkage_result_repo.first(conditions)
      if linkage_result.nil?
        return nil
      end

      if linkage_result.linkage_id
        linkage_result.linkage = linkage = @linkage_repo.first({ :id => linkage_result.linkage_id })

        if linkage.dataset_1_id
          linkage.dataset_1 = @dataset_repo.first({ :id => linkage.dataset_1_id })
        end

        if linkage.dataset_2_id
          if linkage.dataset_1_id == linkage.dataset_2_id
            linkage.dataset_2 = linkage.dataset_1
          else
            linkage.dataset_2 = @dataset_repo.first({ :id => linkage.dataset_2_id })
          end
        end
      end

      if linkage_result.job_id
        linkage_result.job = @job_repo.first({ :id => linkage_result.job_id })
      end

      linkage_result
    end
  end
end
