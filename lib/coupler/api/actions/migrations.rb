module Coupler::API
  module Migrations
    autoload :Create, "coupler/api/actions/migrations/create"
    autoload :Show, "coupler/api/actions/migrations/show"
    autoload :Index, "coupler/api/actions/migrations/index"
  end
end
