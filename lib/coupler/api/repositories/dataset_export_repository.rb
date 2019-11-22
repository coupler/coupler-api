module Coupler::API
  class DatasetExportRepository < Repository
    def initialize(*args)
      super
      @name = :dataset_exports
      @constructor = DatasetExport
    end
  end
end
