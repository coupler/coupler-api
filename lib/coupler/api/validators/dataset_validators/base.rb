module Coupler::API
  module DatasetValidators
    class Base
      def self.dependencies
        ['DatasetRepository']
      end

      def initialize(dataset_repo)
        @dataset_repo = dataset_repo
      end

      def validate(data)
        if !data.is_a?(Hash)
          raise ArgumentError, "expected argument to be a Hash"
        end
        errors = []

        if data[:name].nil? || data[:name].empty?
          errors.push("name must be present")
        else
          # check name uniqueness
          #
          # FIXME: this needs to be abstracted inside an expression creation
          # class so that we're not relying specifically on Sequel, in case a
          # different adapter than SequelAdapter is in use!
          conditions = Sequel[name: data[:name]]
          if data[:id].is_a?(Integer)
            conditions = conditions & Sequel.~(id: data[:id])
          end
          if @dataset_repo.count(conditions) > 0
            errors.push("name is already taken")
          end
        end

        errors
      end
    end
  end
end
