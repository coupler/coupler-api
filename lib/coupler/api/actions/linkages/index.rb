module Coupler::API
  module Linkages
    class Index
      def initialize(repo)
        @repo = repo
      end

      def self.dependencies
        ['LinkageRepository']
      end

      def run
        @repo.find.collect(&:to_h)
      end
    end
  end
end
