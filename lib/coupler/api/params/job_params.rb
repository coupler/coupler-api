module Coupler
  module API
    module JobParams
      autoload :Base, "coupler/api/params/job_params/base"
      autoload :Create, "coupler/api/params/job_params/create"
      autoload :Update, "coupler/api/params/job_params/update"
      autoload :Show, "coupler/api/params/job_params/show"
      autoload :Linkage, "coupler/api/params/job_params/linkage"
    end
  end
end
