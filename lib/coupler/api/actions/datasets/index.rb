module Coupler
  module API
    module Datasets
      class Index
        def initialize(repo)
          @repo = repo
        end

        def self.dependencies
          ['DatasetRepository']
        end

        def run
          @repo.find
        end
      end
    end
  end
end
