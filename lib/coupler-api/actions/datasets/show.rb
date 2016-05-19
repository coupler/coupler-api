module CouplerAPI
  module Datasets
    class Show
      def initialize(repo)
        @repo = repo
      end

      def self.dependencies
        ['DatasetRepository']
      end

      def run(params)
        errors = DatasetParams::Show.validate(params)
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
