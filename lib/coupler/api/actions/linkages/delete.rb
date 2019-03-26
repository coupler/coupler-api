module Coupler::API
  module Linkages
    class Delete
      def initialize(destroyer, validator)
        @destroyer = destroyer
        @validator = validator
      end

      def self.dependencies
        ['LinkageDestroyer', 'LinkageValidators::Show']
      end

      def run(params)
        errors = @validator.validate(params)
        if errors.empty?
          linkage = @destroyer.destroy(id: params[:id])
          if linkage.nil?
            { 'errors' => 'not found' }
          else
            { 'id' => linkage.id }
          end
        else
          { 'errors' => errors }
        end
      end
    end
  end
end
