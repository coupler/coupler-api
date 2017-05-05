module CouplerAPI
  module LinkageResults
    class Show
      def initialize(repo, validator)
        @repo = repo
        @validator = validator
      end

      def self.dependencies
        ['LinkageResultRepository', 'LinkageResultValidators::Show']
      end

      def run(params)
        errors = @validator.validate(params)
        if errors.empty?
          linkage_result = @repo.first(params)
          if linkage_result.nil?
            { 'errors' => ['not found'] }
          else
            linkage_result.to_h
          end
        else
          { 'errors' => errors }
        end
      end
    end
  end
end
