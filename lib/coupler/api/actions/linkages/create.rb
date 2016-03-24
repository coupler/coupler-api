module Coupler
  module API
    module Linkages
      class Create
        def initialize(repo)
          @repo = repo
        end

        def self.dependencies
          ['LinkageRepository']
        end

        def run(params)
          errors = LinkageParams::Create.validate(params)
          if errors.empty?
            linkage = @repo.create(params)
            { 'id' => linkage.id }
          else
            { 'errors' => errors }
          end
        end
      end
    end
  end
end
