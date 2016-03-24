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
    autoload :LinkageRepository, "coupler/api/repositories/linkage_repository"
    autoload :ComparatorRepository, "coupler/api/repositories/comparator_repository"

    # actions
    autoload :Datasets, "coupler/api/actions/datasets"
    autoload :Linkages, "coupler/api/actions/linkages"
    autoload :Comparators, "coupler/api/actions/comparators"

    # routers
    autoload :DatasetRouter, "coupler/api/routers/dataset_router"
    autoload :LinkageRouter, "coupler/api/routers/linkage_router"
    autoload :ComparatorRouter, "coupler/api/routers/comparator_router"

    # controllers
    autoload :DatasetController, "coupler/api/controllers/dataset_controller"
    autoload :LinkageController, "coupler/api/controllers/linkage_controller"
    autoload :ComparatorController, "coupler/api/controllers/comparator_controller"

    # params
    autoload :DatasetParams, "coupler/api/params/dataset_params"
    autoload :LinkageParams, "coupler/api/params/linkage_params"
    autoload :ComparatorParams, "coupler/api/params/comparator_params"

    # entities
    autoload :Dataset, "coupler/api/entities/dataset"
    autoload :Linkage, "coupler/api/entities/linkage"
    autoload :Comparator, "coupler/api/entities/comparator"
  end
end
