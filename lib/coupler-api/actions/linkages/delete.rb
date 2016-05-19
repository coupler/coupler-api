module CouplerAPI
  module Linkages
    class Delete
      def initialize(repo)
        @repo = repo
      end

      def self.dependencies
        ['LinkageRepository']
      end

      def run(params)
        errors = LinkageParams::Show.validate(params)
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
