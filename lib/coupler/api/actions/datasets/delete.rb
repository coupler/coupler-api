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
          errors = DatasetParams::Show.validate(params)
          if errors.empty?
            id = params[:id]
            num = @repo.delete(id)
            if num == 0
              { 'errors' => 'not found' }
            else
              { 'id' => id }
            end
          else
            { 'errors' => errors }
          end
        end
      end
    end
  end
end
