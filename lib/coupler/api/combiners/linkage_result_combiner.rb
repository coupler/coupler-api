module Coupler::API
  class LinkageResultCombiner
    def initialize(linkage_result_repo, job_repo)
      @linkage_result_repo = linkage_result_repo
      @job_repo = job_repo
    end

    def self.dependencies
      ['LinkageResultRepository', 'JobRepository']
    end

    def find_all(conditions)
      @linkage_result_repo.find(conditions).collect do |linkage_result|
        if linkage_result.job_id
          linkage_result.job = @job_repo.first({ :id => linkage_result.job_id })
        end
        linkage_result
      end
    end
  end
end
