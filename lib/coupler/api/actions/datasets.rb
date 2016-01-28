module Coupler
  module API
    module Datasets
      autoload :Index, "coupler/api/actions/datasets/index"
      autoload :Create, "coupler/api/actions/datasets/create"
      autoload :Show, "coupler/api/actions/datasets/show"
    end
  end
end
