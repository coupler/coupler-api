module CouplerAPI
  class LinkageResultRepository < Repository
    def initialize(*args)
      super
      @name = :linkage_results
      @constructor = LinkageResult
    end
  end
end
