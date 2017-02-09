module CouplerAPI
  module Linkages
    class Update
      def initialize(repo, validator)
        @repo = repo
        @validator = validator
      end

      def self.dependencies
        ['LinkageRepository', 'LinkageValidators::Update']
      end

      def run(params)
        errors = @validator.validate(params)
        if !errors.empty?
          return { 'errors' => errors }
        end

        linkage = @repo.first(id: params[:id])
        if linkage.nil?
          return { 'errors' => { 'id' => ['was not found'] } }
        end

        linkage.update(params)
        @repo.save(linkage)
        { 'id' => linkage.id }
      end
    end
  end
end
