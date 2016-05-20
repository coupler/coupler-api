module CouplerAPI
  module LinkageValidators
    autoload :Base, "coupler-api/validators/linkage_validators/base"
    autoload :Create, "coupler-api/validators/linkage_validators/create"
    autoload :Update, "coupler-api/validators/linkage_validators/update"
    autoload :Show, "coupler-api/validators/linkage_validators/show"
  end
end
