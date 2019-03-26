module Coupler::API
  module Datasets
    class Show
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
          dataset = @repo.first(id: params[:id])
          if dataset.nil?
            { 'errors' => 'not found' }
          else
            include_fields = true
            if params.has_key?(:include_fields)
              include_fields = params[:include_fields]
            end
            dataset.to_h(include_fields)
          end
        else
          { 'errors' => errors }
        end
      end
    end
  end
end
