module CouplerAPI
  module ComparatorParams
    VALID_KINDS = %w{compare strcompare within}
    VALID_COMPARE_OPERATIONS = %w{not_equal greater_than greater_than_or_equal less_than_or_equal less_than equal}
    VALID_STRCOMPARE_OPERATIONS = %w{jarowinkler reverse_jarowinkler damerau_levenshtein}

    class Base
      def self.process(data)
        if !data.is_a?(Hash)
          raise ArgumentError, "expected argument to be a Hash"
        end

        result = {}
        data.each_pair do |key, value|
          if %w{kind set_1 set_2 order linkage_id options}.include?(key)
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

        if data[:set_1].nil? || data[:set_1].empty?
          errors.push("set_1 must be present")
        elsif !data[:set_1].is_a?(Array)
          errors.push("set_1 is not valid")
        elsif !data[:set_1].all? { |x| x.is_a?(String) }
          errors.push("set_1 is not valid")
        end

        if data[:set_2].nil? || data[:set_2].empty?
          errors.push("set_2 must be present")
        elsif !data[:set_2].is_a?(Array)
          errors.push("set_2 is not valid")
        elsif !data[:set_2].all? { |x| x.is_a?(String) }
          errors.push("set_2 is not valid")
        end

        if !data[:order].nil? && !data[:order].is_a?(Fixnum)
          errors.push("order is not valid")
        end

        if data[:options].nil?
          errors.push('options must be present')
        elsif !data[:options].is_a?(Hash)
          errors.push('options is not valid')
        end

        if data[:linkage_id].nil?
          errors.push("linkage_id must be present")
        elsif !data[:linkage_id].is_a?(Fixnum)
          errors.push("linkage_id is not valid")
        end

        case data[:kind]
        when 'compare'
          if data[:set_1].is_a?(Array) && data[:set_2].is_a?(Array) && data[:set_1].length != data[:set_2].length
            errors.push("sets must be equal in length")
          end

          if data[:options].is_a?(Hash)
            if data[:options]['operation'].nil? || data[:options]['operation'].empty?
              errors.push('options.operation must be present')
            elsif !VALID_COMPARE_OPERATIONS.include?(data[:options]['operation'])
              errors.push('options.operation is not valid')
            end
          end
        when 'strcompare'
          if data[:set_1].is_a?(Array) && data[:set_1].length != 1
            errors.push('set_1 is not valid')
          end

          if data[:set_2].is_a?(Array) && data[:set_2].length != 1
            errors.push('set_2 is not valid')
          end

          if data[:options].is_a?(Hash)
            if data[:options]['operation'].nil? || data[:options]['operation'].empty?
              errors.push('options.operation must be present')
            elsif !VALID_STRCOMPARE_OPERATIONS.include?(data[:options]['operation'])
              errors.push('options.operation is not valid')
            end
          end
        when 'within'
          if data[:set_1].is_a?(Array) && data[:set_1].length != 1
            errors.push('set_1 is not valid')
          end

          if data[:set_2].is_a?(Array) && data[:set_2].length != 1
            errors.push('set_2 is not valid')
          end

          if data[:options].is_a?(Hash)
            if data[:options]['value'].nil? || data[:options]['value'].empty?
              errors.push('options.value must be present')
            end
          end
        end

        errors
      end
    end
  end
end
