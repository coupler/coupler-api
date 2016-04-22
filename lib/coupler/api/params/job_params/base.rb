module Coupler
  module API
    module JobParams
      VALID_KINDS = %w{linkage}

      class Base
        def self.process(data)
          if !data.is_a?(Hash)
            raise ArgumentError, "expected argument to be a Hash"
          end

          result = {}
          data.each_pair do |key, value|
            if %w{kind linkage_id}.include?(key)
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
end
