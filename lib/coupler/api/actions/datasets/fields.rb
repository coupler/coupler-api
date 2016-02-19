module Coupler
  module API
    module Datasets
      class Fields
        def initialize(repo)
          @repo = repo
        end

        def self.dependencies
          ['DatasetRepository']
        end

        def run(params)
          if params.valid?
            dataset = @repo.first(params.to_hash)
            if dataset.nil?
              { 'errors' => 'not found' }
            else
              { 'fields' => dataset.fields }
            end
          else
            { 'errors' => params.errors }
          end
        end
      end
    end
  end
end
