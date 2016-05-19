module CouplerAPI
  module Comparators
    class Delete
      def initialize(repo)
        @repo = repo
      end

      def self.dependencies
        ['ComparatorRepository']
      end

      def run(params)
        errors = ComparatorParams::Show.validate(params)
        if errors.empty?
          id = params[:id]
          num = @repo.delete(id)
          if num == 0
            { 'errors' => 'not found' }
          else
            { 'id' => id }
          end
        else
          { 'errors' => errors }
        end
      end
    end
  end
end
