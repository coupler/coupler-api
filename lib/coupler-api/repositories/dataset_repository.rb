module CouplerAPI
  class DatasetRepository < Repository
    def initialize(*args)
      super
      @name = :datasets
      @constructor = Dataset
    end
  end
end
