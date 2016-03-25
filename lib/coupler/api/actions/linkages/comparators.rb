module Coupler
  module API
    module Linkages
      class Comparators
        def initialize(repo)
          @repo = repo
        end

        def self.dependencies
          ['ComparatorRepository']
        end

        def run(params)
          errors = LinkageParams::Show.validate(params)
          if errors.empty?
            conditions = { :linkage_id => params['id'] }
            @repo.find(conditions).collect(&:to_h)
          else
            { 'errors' => errors }
          end
        end
      end
    end
  end
end
