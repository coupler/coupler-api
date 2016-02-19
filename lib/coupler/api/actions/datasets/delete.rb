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
            data = params.to_hash
            id = data[:id]
            num = @repo.delete(id)
            if num == 0
              { 'errors' => 'not found' }
            else
              { 'id' => id }
            end
          else
            { 'errors' => params.errors }
          end
        end
      end
    end
  end
end
