module CouplerAPI
  module Linkages
    class Update
      def initialize(repo, validator)
        @repo = repo
        @validator = validator
      end

      def self.dependencies
        ['LinkageRepository', 'LinkageValidators::Update']
      end

      def run(params)
        errors = @validator.validate(params)
        if errors.empty?
          id = params.delete(:id)

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
