module Coupler
  module API
    module Datasets
      class Delete
        def initialize(repo)
          @repo = repo
        end

        def self.dependencies
          ['DatasetRepository']
        end

        def run(params)
          if params.valid?
            @repo.delete(params.to_hash).first
          else
            { 'errors' => params.errors }
          end
        end
      end
    end
  end
end
