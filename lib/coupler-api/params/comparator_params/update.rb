module CouplerAPI
  module ComparatorParams
    class Update < Base
      def process(data)
        result = super
        if data.has_key?('id')
          result[:id] = data['id']
        end
        result
      end
    end
  end
end
