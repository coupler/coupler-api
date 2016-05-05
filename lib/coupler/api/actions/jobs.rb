module Coupler
  module API
    module Jobs
      #autoload :Index, "coupler/api/actions/jobs/index"
      autoload :Create, "coupler/api/actions/jobs/create"
      #autoload :Update, "coupler/api/actions/jobs/update"
      autoload :Show, "coupler/api/actions/jobs/show"
      #autoload :Delete, "coupler/api/actions/jobs/delete"

      autoload :Linkage, "coupler/api/actions/jobs/linkage"
    end
  end
end
