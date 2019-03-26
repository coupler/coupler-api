module Coupler::API
  module DatasetParams
    class Records < Base
      def self.valid_keys
        @valid_keys ||= %w{id limit offset}
      end

      def process(data)
        result = super

        if result[:limit] =~ /^\d+$/
          result[:limit] = result[:limit].to_i
        end

        if result[:offset] =~ /^\d+$/
          result[:offset] = result[:offset].to_i
        end

        result
      end
    end
  end
end
