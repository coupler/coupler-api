module Coupler
  module API
    class DatasetRepository < Repository
      def initialize(*args)
        super
        @name = :datasets
      end
    end
  end
end
