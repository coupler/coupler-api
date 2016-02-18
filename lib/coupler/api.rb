require "thor"
require "rack"
require "json"
require "rack/cors"
require "rom-sql"
require "rom-repository"

module Coupler
  module API
    autoload :Application, "coupler/api/application"
    autoload :CLI, "coupler/api/cli"
    autoload :Injector, "coupler/api/injector"

    # repositories
    autoload :DatasetRepository, "coupler/api/repositories/dataset_repository"

    # actions
    autoload :Datasets, "coupler/api/actions/datasets"

    # routers
    autoload :DatasetRouter, "coupler/api/routers/dataset_router"

    # controllers
    autoload :DatasetController, "coupler/api/controllers/dataset_controller"

    # params
    autoload :DatasetParams, "coupler/api/params/dataset_params"

    # entities
    autoload :Dataset, "coupler/api/entities/dataset"
  end
end
