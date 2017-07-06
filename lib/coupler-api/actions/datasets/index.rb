module CouplerAPI
  module Datasets
    class Index
      def initialize(repo, validator)
        @repo = repo
        @validator = validator
      end

      def self.dependencies
        ['DatasetRepository', 'DatasetValidators::Index']
      end

      def run(params)
        errors = @validator.validate(params)
        if errors.empty?
          include_fields = false
          if params.has_key?(:include_fields)
            include_fields = params[:include_fields]
          end
          @repo.find.collect { |ds| ds.to_h(include_fields) }
        else
          { 'errors' => errors }
        end
      end
    end
  end
end
