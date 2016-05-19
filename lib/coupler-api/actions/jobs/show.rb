module CouplerAPI
  module Jobs
    class Show
      def initialize(repo)
        @repo = repo
      end

      def self.dependencies
        ['JobRepository']
      end

      def run(params)
        errors = JobParams::Show.validate(params)
        if errors.empty?
          job = @repo.first(params)
          if job.nil?
            { 'errors' => 'not found' }
          else
            job.to_h
          end
        else
          { 'errors' => errors }
        end
      end
    end
  end
end
