module CouplerAPI
  module Linkages
    class Show
      def initialize(repo)
        @repo = repo
      end

      def self.dependencies
        ['LinkageRepository']
      end

      def run(params)
        errors = LinkageParams::Show.validate(params)
        if errors.empty?
          linkage = @repo.first(params)
          if linkage.nil?
            { 'errors' => 'not found' }
          else
            linkage.to_h
          end
        else
          { 'errors' => errors }
        end
      end
    end
  end
end
