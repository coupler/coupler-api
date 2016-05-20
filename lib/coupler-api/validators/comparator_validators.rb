module CouplerAPI
  module ComparatorValidators
    autoload :Base, "coupler-api/validators/comparator_validators/base"
    autoload :Create, "coupler-api/validators/comparator_validators/create"
    autoload :Update, "coupler-api/validators/comparator_validators/update"
    autoload :Show, "coupler-api/validators/comparator_validators/show"
  end
end
