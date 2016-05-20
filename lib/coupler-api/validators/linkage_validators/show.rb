module CouplerAPI
  module LinkageValidators
    class Show
      def self.dependencies
        []
      end

      def validate(data)
        if !data.is_a?(Hash)
          raise ArgumentError, "expected argument to be a Hash"
        end

        errors = []
        if data[:id].nil?
          errors.push("id must be present")
        elsif !data[:id].is_a?(Fixnum)
          errors.push("id must be a number")
        end

        errors
      end
    end
  end
end
