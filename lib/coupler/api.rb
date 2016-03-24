require "thor"
require "rack"
require "json"
require "rack/cors"
require "rom-sql"
require "rom-repository"
require "hashery"

module Coupler
  module API
    autoload :Injector, "coupler/api/injector"
    autoload :Application, "coupler/api/application"
    autoload :Builder, "coupler/api/builder"
    autoload :CLI, "coupler/api/cli"

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
