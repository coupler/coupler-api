module CouplerAPI
  module Datasets
    class Create
      def initialize(repo)
        @repo = repo
      end

      def self.dependencies
        ['DatasetRepository']
      end

      def run(params)
        errors = DatasetParams::Create.validate(params)
        if errors.empty?
          dataset = @repo.create(params)
          { 'id' => dataset.id }
        else
          { 'errors' => errors }
        end
      end
    end
  end
end
