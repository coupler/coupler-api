module CouplerAPI
  module Linkages
    class Show
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
          linkage = @repo.first(params)
          if linkage.nil?
            { 'errors' => 'not found' }
          else
            linkage.to_h
          end
        else
          { 'errors' => errors }
        end
      end
    end
  end
end
