module Coupler::API
  module MigrationValidators
    autoload :Create, "coupler/api/validators/migration_validators/create"
    autoload :Show, "coupler/api/validators/migration_validators/show"
    autoload :Index, "coupler/api/validators/migration_validators/index"
  end
end
