require "thor"
require "rack"
require "json"
require "rack/cors"
require "sequel"
require "hashery"
require "linkage"

module CouplerAPI
  autoload :Injector, "coupler-api/injector"
  autoload :Repository, "coupler-api/repository"
  autoload :Router, "coupler-api/router"
  autoload :Controller, "coupler-api/controller"
  autoload :Application, "coupler-api/application"
  autoload :Builder, "coupler-api/builder"
  autoload :CLI, "coupler-api/cli"

  # adapters
  autoload :SequelAdapter, "coupler-api/adapters/sequel_adapter"

  # repositories
  autoload :DatasetRepository, "coupler-api/repositories/dataset_repository"
  autoload :LinkageRepository, "coupler-api/repositories/linkage_repository"
  autoload :ComparatorRepository, "coupler-api/repositories/comparator_repository"
  autoload :JobRepository, "coupler-api/repositories/job_repository"
  autoload :LinkageResultRepository, "coupler-api/repositories/linkage_result_repository"

  # actions
  autoload :Datasets, "coupler-api/actions/datasets"
  autoload :Linkages, "coupler-api/actions/linkages"
  autoload :Comparators, "coupler-api/actions/comparators"
  autoload :Jobs, "coupler-api/actions/jobs"
  autoload :LinkageResults, "coupler-api/actions/linkage_results"

  # routers
  autoload :DatasetRouter, "coupler-api/routers/dataset_router"
  autoload :LinkageRouter, "coupler-api/routers/linkage_router"
  autoload :ComparatorRouter, "coupler-api/routers/comparator_router"
  autoload :JobRouter, "coupler-api/routers/job_router"
  autoload :LinkageResultRouter, "coupler-api/routers/linkage_result_router"

  # controllers
  autoload :DatasetController, "coupler-api/controllers/dataset_controller"
  autoload :LinkageController, "coupler-api/controllers/linkage_controller"
  autoload :ComparatorController, "coupler-api/controllers/comparator_controller"
  autoload :JobController, "coupler-api/controllers/job_controller"
  autoload :LinkageResultController, "coupler-api/controllers/linkage_result_controller"

  # params
  autoload :DatasetParams, "coupler-api/params/dataset_params"
  autoload :LinkageParams, "coupler-api/params/linkage_params"
  autoload :ComparatorParams, "coupler-api/params/comparator_params"
  autoload :JobParams, "coupler-api/params/job_params"
  autoload :LinkageResultParams, "coupler-api/params/linkage_result_params"

  # validators
  autoload :DatasetValidators, "coupler-api/validators/dataset_validators"
  autoload :LinkageValidators, "coupler-api/validators/linkage_validators"
  autoload :ComparatorValidators, "coupler-api/validators/comparator_validators"
  autoload :JobValidators, "coupler-api/validators/job_validators"
  autoload :LinkageResultValidators, "coupler-api/validators/linkage_result_validators"

  # entities
  autoload :Dataset, "coupler-api/entities/dataset"
  autoload :Linkage, "coupler-api/entities/linkage"
  autoload :Comparator, "coupler-api/entities/comparator"
  autoload :Job, "coupler-api/entities/job"
  autoload :LinkageResult, "coupler-api/entities/linkage_result"

  # combiners
  autoload :LinkageCombiner, "coupler-api/combiners/linkage_combiner"
  autoload :JobCombiner, "coupler-api/combiners/job_combiner"

  # destroyers
  autoload :LinkageDestroyer, "coupler-api/destroyers/linkage_destroyer"

  # runners
  autoload :Runner, "coupler-api/runner"
  autoload :LinkageRunner, "coupler-api/runners/linkage_runner"
end

require 'coupler-api/entity'
