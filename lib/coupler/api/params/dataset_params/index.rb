module Coupler::API
  module DatasetParams
    class Index
      def self.dependencies
        []
      end

      def process(data)
        if !data.is_a?(Hash)
          raise ArgumentError, "expected argument to be a Hash"
        end

        result = {}
        data.each_pair do |key, value|
          case key
          when 'include_fields', 'include_pending'
            value =
              case value
              when "true" then true
              when "false" then false
              else
                value
              end
            result[key.to_sym] = value
          end
        end
        result
      end
    end
  end
end
