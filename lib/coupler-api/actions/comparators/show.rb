module CouplerAPI
  module Comparators
    class Show
      def initialize(repo)
        @repo = repo
      end

      def self.dependencies
        ['ComparatorRepository']
      end

      def run(params)
        errors = ComparatorParams::Show.validate(params)
        if errors.empty?
          comparator = @repo.first(params)
          if comparator.nil?
            { 'errors' => 'not found' }
          else
            comparator.to_h
          end
        else
          { 'errors' => errors }
        end
      end
    end
  end
end
