module Coupler
  module API
    module ComparatorParams
      class Show
        def self.process(data)
          if !data.is_a?(Hash)
            raise ArgumentError, "expected argument to be a Hash"
          end

          data.select do |key, value|
            %w{id}.include?(key)
          end
        end

        def self.validate(data)
          if !data.is_a?(Hash)
            raise ArgumentError, "expected argument to be a Hash"
          end

          errors = []
          if data["id"].nil?
            errors.push("id must be present")
          elsif !data["id"].is_a?(Fixnum)
            errors.push("id must be a number")
          end

          errors
        end
      end
    end
  end
end
