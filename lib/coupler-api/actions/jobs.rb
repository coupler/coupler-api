module CouplerAPI
  module Jobs
    autoload :Index, "coupler-api/actions/jobs/index"
    autoload :Create, "coupler-api/actions/jobs/create"
    #autoload :Update, "coupler-api/actions/jobs/update"
    autoload :Show, "coupler-api/actions/jobs/show"
    #autoload :Delete, "coupler-api/actions/jobs/delete"

    autoload :Run, "coupler-api/actions/jobs/run"
  end
end
