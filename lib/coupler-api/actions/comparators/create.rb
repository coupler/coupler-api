module CouplerAPI
  module Comparators
    class Create
      def initialize(repo)
        @repo = repo
      end

      def self.dependencies
        ['ComparatorRepository']
      end

      def run(params)
        errors = ComparatorParams::Create.validate(params)
        if errors.empty?
          comparator = @repo.create(params)
          { 'id' => comparator.id }
        else
          { 'errors' => errors }
        end
      end
    end
  end
end
