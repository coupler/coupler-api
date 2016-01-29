module Coupler
  module API
    module Datasets
      class Update
        def initialize(repo)
          @repo = repo
        end

        def self.dependencies
          ['DatasetRepository']
        end

        def run(params)
          if params.valid?
            data = params.to_hash
            id = data.delete(:id)

            num = @repo.update({ :id => id }, data)
            if num > 0
              { 'id' => id }
            else
              nil
            end
          else
            { 'errors' => params.errors }
          end
        end
      end
    end
  end
end
