module Coupler
  module API
    module Datasets
      class Show
        def initialize(repo)
          @repo = repo
        end

        def self.dependencies
          ['DatasetRepository']
        end

        def run(params)
          if params.valid?

            @repo.first(params.to_hash)
          else
            { 'errors' => params.errors }
          end
        end
      end
    end
  end
end
