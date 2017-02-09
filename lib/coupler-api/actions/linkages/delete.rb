module CouplerAPI
  module Linkages
    class Delete
      def initialize(repo, validator)
        @repo = repo
        @validator = validator
      end

      def self.dependencies
        ['LinkageRepository', 'LinkageValidators::Show']
      end

      def run(params)
        errors = @validator.validate(params)
        if errors.empty?
          linkage = @repo.first(id: params[:id])
          if linkage.nil?
            { 'errors' => 'not found' }
          else
            @repo.delete(linkage)
            { 'id' => linkage.id }
          end
        else
          { 'errors' => errors }
        end
      end
    end
  end
end
