module CouplerAPI
  module Jobs
    class Index
      def initialize(repo)
        @repo = repo
      end

      def self.dependencies
        ['JobRepository']
      end

      def run
        @repo.find.collect(&:to_h)
      end
    end
  end
end
