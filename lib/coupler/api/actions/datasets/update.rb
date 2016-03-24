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
          errors = DatasetParams::Update.validate(params)
          if errors.empty?
            id = params.delete('id')

            num = @repo.update(id, params)
            if num > 0
              { 'id' => id }
            else
              nil
            end
          else
            { 'errors' => errors }
          end
        end
      end
    end
  end
end
