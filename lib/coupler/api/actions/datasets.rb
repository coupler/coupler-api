module Coupler::API
  module Datasets
    autoload :Index, "coupler/api/actions/datasets/index"
    autoload :Create, "coupler/api/actions/datasets/create"
    autoload :Update, "coupler/api/actions/datasets/update"
    autoload :Show, "coupler/api/actions/datasets/show"
    autoload :Delete, "coupler/api/actions/datasets/delete"
    autoload :Fields, "coupler/api/actions/datasets/fields"
    autoload :Records, "coupler/api/actions/datasets/records"
    autoload :CountRecords, "coupler/api/actions/datasets/count_records"
  end
end
