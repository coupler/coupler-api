module CouplerAPI
  module JobParams
    class Linkage
      def self.process(data)
        if !data.is_a?(Hash)
          raise ArgumentError, "expected argument to be a Hash"
        end

        result = {}
        data.each_pair do |key, value|
          if %w{id}.include?(key)
            result[key.to_sym] = value
          end
        end
        result
      end

      def self.validate(data)
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
