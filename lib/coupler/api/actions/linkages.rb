module Coupler::API
  module Linkages
    autoload :Index, "coupler/api/actions/linkages/index"
    autoload :Create, "coupler/api/actions/linkages/create"
    autoload :Update, "coupler/api/actions/linkages/update"
    autoload :Show, "coupler/api/actions/linkages/show"
    autoload :Delete, "coupler/api/actions/linkages/delete"
    autoload :Comparators, "coupler/api/actions/linkages/comparators"
  end
end