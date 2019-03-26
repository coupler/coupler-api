module Coupler::API
  module DatasetParams
    class Show
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
          when "id"
            # no-op
          when "include_fields"
            value =
              case value
              when "true" then true
              when "false" then false
              else
                value
              end
          else
            next
          end
          result[key.to_sym] = value
        end
        result
      end
    end
  end
end
