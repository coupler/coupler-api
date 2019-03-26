module Coupler::API
  module JobValidators
    class Base
      VALID_KINDS = %w{linkage migration}

      def self.dependencies
        []
      end

      def validate(data)
        if !data.is_a?(Hash)
          raise ArgumentError, "expected argument to be a Hash"
        end

        errors = []

        if data[:kind].nil? || data[:kind].empty?
          errors.push("kind must be present")
        elsif !VALID_KINDS.include?(data[:kind])
          errors.push("kind is not valid")
        elsif data[:kind] == 'linkage'
          if data[:linkage_id].nil?
            errors.push("linkage_id must be present when kind is 'linkage'")
          elsif !data[:linkage_id].is_a?(Integer)
            errors.push("linkage_id is not valid")
          end

          if !data[:migration_id].nil?
            errors.push("migration_id must not be present when kind is 'linkage'")
          end
        elsif data[:kind] == 'migration'
          if data[:migration_id].nil?
            errors.push("migration_id must be present when kind is 'migration'")
          elsif !data[:migration_id].is_a?(Integer)
            errors.push("migration_id is not valid")
          end

          if !data[:linkage_id].nil?
            errors.push("linkage_id must not be present when kind is 'migration'")
          end
        end

        errors
      end
    end
  end
end
