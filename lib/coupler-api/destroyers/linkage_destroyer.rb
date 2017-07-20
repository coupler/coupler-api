module CouplerAPI
  class LinkageDestroyer
    def self.dependencies
      [
        'LinkageRepository', 'ComparatorRepository',
        'JobRepository', 'LinkageResultRepository'
      ]
    end

    def initialize(linkage_repo, comparator_repo, job_repo, linkage_result_repo)
      @linkage_repo = linkage_repo
      @comparator_repo = comparator_repo
      @job_repo = job_repo
      @linkage_result_repo = linkage_result_repo
    end

    def destroy(conditions, which = :all)
      if which != :all && !which.is_a?(Array)
        raise "'which' must be :all or an array"
      end

      linkage = @linkage_repo.first(conditions)
      if linkage.nil?
        return nil
      end
      @linkage_repo.delete(linkage)

      if which == :all || which.include?(:comparators)
        @comparator_repo.find(:linkage_id => linkage.id).each do |comparator|
          @comparator_repo.delete(comparator)
        end
      end

      if which == :all || which.include?(:jobs)
        @job_repo.find(:linkage_id => linkage.id).each do |job|
          @job_repo.delete(job)
        end
      end

      if which == :all || which.include?(:linkage_results)
        @linkage_result_repo.find(:linkage_id => linkage.id).each do |linkage_result|
          @linkage_result_repo.delete(linkage_result)
        end
      end

      linkage
    end
  end
end
