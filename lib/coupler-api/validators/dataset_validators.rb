module CouplerAPI
  module DatasetValidators
    autoload :Base, "coupler-api/validators/dataset_validators/base"
    autoload :Create, "coupler-api/validators/dataset_validators/create"
    autoload :Update, "coupler-api/validators/dataset_validators/update"
    autoload :Show, "coupler-api/validators/dataset_validators/show"
  end
end
