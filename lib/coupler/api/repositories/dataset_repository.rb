module Coupler::API
  class DatasetRepository < Repository
    def initialize(*args)
      super
      @name = :datasets
      @constructor = Dataset
    end
  end
end
