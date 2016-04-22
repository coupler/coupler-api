module Coupler
  module API
    module LinkageParams
      class Base
        def self.process(data)
          if !data.is_a?(Hash)
            raise ArgumentError, "expected argument to be a Hash"
          end

          result = {}
          data.each_pair do |key, value|
            if %w{name description dataset_1_id dataset_2_id}.include?(key)
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

          if data[:name].nil? || data[:name].empty?
            errors.push("name must be present")
          end

          if data[:dataset_1_id].nil?
            errors.push("dataset_1_id must be present")
          elsif !data[:dataset_1_id].is_a?(Fixnum)
            errors.push("dataset_1_id must be an integer")
          end

          if data[:dataset_2_id].nil?
            errors.push("dataset_2_id must be present")
          elsif !data[:dataset_2_id].is_a?(Fixnum)
            errors.push("dataset_2_id must be an integer")
          end

          errors
        end
      end
    end
  end
end
