module Coupler::API
  module DatasetValidators
    autoload :Base, "coupler/api/validators/dataset_validators/base"
    autoload :Create, "coupler/api/validators/dataset_validators/create"
    autoload :Update, "coupler/api/validators/dataset_validators/update"
    autoload :Show, "coupler/api/validators/dataset_validators/show"
    autoload :Index, "coupler/api/validators/dataset_validators/index"
    autoload :Records, "coupler/api/validators/dataset_validators/records"
    autoload :CountRecords, "coupler/api/validators/dataset_validators/count_records"
  end
end
