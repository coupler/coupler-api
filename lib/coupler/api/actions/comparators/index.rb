module Coupler::API
  module Comparators
    class Index
      def initialize(repo)
        @repo = repo
      end

      def self.dependencies
        ['ComparatorRepository']
      end

      def run
        @repo.find.collect(&:to_h)
      end
    end
  end
end
