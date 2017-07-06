module CouplerAPI
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
          if key == 'include_fields'
            value =
              case value
              when "true" then true
              when "false" then false
              else
                value
              end
            result[:include_fields] = value
          end
        end
        result
      end
    end
  end
end
