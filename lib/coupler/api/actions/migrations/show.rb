module Coupler::API
  module Migrations
    class Show
      def initialize(combiner, validator)
        @combiner = combiner
        @validator = validator
      end

      def self.dependencies
        ['MigrationCombiner', 'MigrationValidators::Show']
      end

      def run(params)
        errors = @validator.validate(params)
        if errors.empty?
          migration = @combiner.find(id: params[:id])
          if migration.nil?
            { 'errors' => 'not found' }
          else
            migration.to_h
          end
        else
          { 'errors' => errors }
        end
      end
    end
  end
end
