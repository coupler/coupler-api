module Coupler
  module API
    module ComparatorParams
      class Base
        def self.process(data)
          if !data.is_a?(Hash)
            raise ArgumentError, "expected argument to be a Hash"
          end

          data.select do |key, value|
            %w{set_1 set_2 options order linkage_id}
          end
        end

        def self.validate(data)
          if !data.is_a?(Hash)
            raise ArgumentError, "expected argument to be a Hash"
          end

          errors = []

          if data["set_1"].nil? || data["set_1"].empty?
            errors.push("set_1 must be present")
          end

          if data["set_2"].nil? || data["set_2"].empty?
            errors.push("set_2 must be present")
          end

          if !data["order"].nil? && !data["order"].is_a?(Fixnum)
            errors.push("order must be an integer")
          end

          if data["linkage_id"].nil?
            errors.push("linkage_id must be present")
          elsif !data["linkage_id"].is_a?(Fixnum)
            errors.push("linkage_id must be an integer")
          end

          errors
        end
      end
    end
  end
end
