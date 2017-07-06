module CouplerAPI
  module DatasetParams
    autoload :Base, "coupler-api/params/dataset_params/base"
    autoload :Create, "coupler-api/params/dataset_params/create"
    autoload :Update, "coupler-api/params/dataset_params/update"
    autoload :Show, "coupler-api/params/dataset_params/show"
    autoload :Index, "coupler-api/params/dataset_params/index"
  end
end
