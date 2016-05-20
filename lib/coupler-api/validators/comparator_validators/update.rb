module CouplerAPI
  module ComparatorValidators
    class Update < Base
      def validate(data)
        errors = super

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
