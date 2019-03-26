module Coupler::API
  module LinkageValidators
    class Base
      def self.dependencies
        []
      end

      def validate(data)
        if !data.is_a?(Hash)
          raise ArgumentError, "expected argument to be a Hash"
        end

        errors = []

        if data[:name].nil? || data[:name].empty?
          errors.push("name must be present")
        end

        if !data[:threshold].nil?
          if !data[:threshold].is_a?(Numeric)
            errors.push("threshold must be a number")
          elsif data[:threshold] < 0 || data[:threshold] > 1
            errors.push("threshold must be in the range [0, 1]")
          end
        end

        if data[:dataset_1_id].nil?
          errors.push("dataset_1_id must be present")
        elsif !data[:dataset_1_id].is_a?(Integer)
          errors.push("dataset_1_id must be an integer")
        end

        if data[:dataset_2_id].nil?
          errors.push("dataset_2_id must be present")
        elsif !data[:dataset_2_id].is_a?(Integer)
          errors.push("dataset_2_id must be an integer")
        end

        errors
      end
    end
  end
end
