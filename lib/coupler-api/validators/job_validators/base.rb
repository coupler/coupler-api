module CouplerAPI
  module JobValidators
    class Base
      VALID_KINDS = %w{linkage}

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
        end

        if data[:linkage_id].nil?
          errors.push("linkage_id must be present")
        elsif !data[:linkage_id].is_a?(Fixnum)
          errors.push("linkage_id is not valid")
        end

        errors
      end
    end
  end
end
