module Coupler::API
  class JobCombiner
    def initialize(job_repo, linkage_result_repo)
      @job_repo = job_repo
      @linkage_result_repo = linkage_result_repo
    end

    def self.dependencies
      ['JobRepository', 'LinkageResultRepository']
    end

    def find(conditions)
      job = @job_repo.first(conditions)
      if job.nil?
        return nil
      end

      if job.linkage_result_id
        job.linkage_result = @linkage_result_repo.first({ :id => job.linkage_result_id })
      end

      job
    end
  end
end
