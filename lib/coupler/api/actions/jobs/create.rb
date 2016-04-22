module Coupler
  module API
    module Jobs
      class Create
        def initialize(repo)
          @repo = repo
        end

        def self.dependencies
          ['JobRepository']
        end

        def run(params)
          errors = JobParams::Create.validate(params)
          if errors.empty?
            job = @repo.create(params)
            { 'id' => job.id }
          else
            { 'errors' => errors }
          end
        end
      end
    end
  end
end
