module CouplerAPI
  module Datasets
    class Delete
      def initialize(repo, validator)
        @repo = repo
        @validator = validator
      end

      def self.dependencies
        ['DatasetRepository', 'DatasetValidators::Show']
      end

      def run(params)
        errors = @validator.validate(params)
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
