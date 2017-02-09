module CouplerAPI
  module Jobs
    class Create
      def initialize(repo, validator)
        @repo = repo
        @validator = validator
      end

      def self.dependencies
        ['JobRepository', 'JobValidators::Create']
      end

      def run(params)
        errors = @validator.validate(params)
        if errors.empty?
          job = @repo.save(Job.new(params))
          { 'id' => job.id }
        else
          { 'errors' => errors }
        end
      end
    end
  end
end
