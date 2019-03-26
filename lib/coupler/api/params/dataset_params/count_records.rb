module Coupler::API
  module DatasetParams
    class CountRecords < Base
      def self.valid_keys
        ['id']
      end
    end
  end
end
