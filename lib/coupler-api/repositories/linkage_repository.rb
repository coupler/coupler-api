module CouplerAPI
  class LinkageRepository < Repository
    def initialize(*args)
      super
      @name = :linkages
      @constructor = Linkage
    end
  end
end
