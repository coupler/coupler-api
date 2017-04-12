module CouplerAPI
  module JobValidators
    autoload :Base, "coupler-api/validators/job_validators/base"
    autoload :Create, "coupler-api/validators/job_validators/create"
    autoload :Update, "coupler-api/validators/job_validators/update"
    autoload :Show, "coupler-api/validators/job_validators/show"
    autoload :Run, "coupler-api/validators/job_validators/run"
  end
end
