module Coupler::API
  class LinkageResultRepository < Repository
    def initialize(*args)
      super
      @name = :linkage_results
      @constructor = LinkageResult
    end

    def delete(obj)
      if obj.database_path && File.exist?(obj.database_path)
        File.unlink(obj.database_path)
      end
      super
    end
  end
end
