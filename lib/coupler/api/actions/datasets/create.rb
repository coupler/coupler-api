module Coupler
  module API
    module Datasets
      class Create
        def initialize(repo)
          @repo = repo
        end

        def self.dependencies
          ['DatasetRepository']
        end

        def run(params)
          if params.valid?
            id = @repo.create(params.to_hash)
            { 'id' => id }
          else
            { 'errors' => params.errors }
          end
        end
      end
    end
  end
end
