module CouplerAPI
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
          dataset = @repo.first(params)
          if dataset.nil?
            { 'errors' => 'not found' }
          else
            dataset.to_h
          end
        else
          { 'errors' => errors }
        end
      end
    end
  end
end
