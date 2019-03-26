module Coupler::API
  module DatasetParams
    class Create < Base
      def self.valid_keys
        @@valid_keys ||= super() + %w{csv_import_id fields}
      end
    end
  end
end
