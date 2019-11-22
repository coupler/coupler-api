require "thor"
require "rack"
require "json"
require "rack/cors"
require "sequel"
require "hashery"
require "linkage"
require "ethel"
require "ethel-sequel"
require "tmpdir"
require "fileutils"

module Coupler
  module API
    autoload :Application, "coupler/api/application"
    autoload :Builder, "coupler/api/builder"
    autoload :CLI, "coupler/api/cli"
    autoload :Controller, "coupler/api/controller"
    autoload :Entity, "coupler/api/entity"
    autoload :Injector, "coupler/api/injector"
    autoload :Repository, "coupler/api/repository"
    autoload :Router, "coupler/api/router"
    autoload :Runner, "coupler/api/runner"
    autoload :Supervisor, "coupler/api/supervisor"

    # adapters
    autoload :SequelAdapter, "coupler/api/adapters/sequel_adapter"

    # repositories
    autoload :ComparatorRepository, "coupler/api/repositories/comparator_repository"
    autoload :CsvImportRepository, "coupler/api/repositories/csv_import_repository"
    autoload :DatasetRepository, "coupler/api/repositories/dataset_repository"
    autoload :JobRepository, "coupler/api/repositories/job_repository"
    autoload :LinkageRepository, "coupler/api/repositories/linkage_repository"
    autoload :LinkageResultRepository, "coupler/api/repositories/linkage_result_repository"
    autoload :MigrationRepository, "coupler/api/repositories/migration_repository"
    autoload :DatasetExportRepository, "coupler/api/repositories/dataset_export_repository"

    # actions
    autoload :Comparators, "coupler/api/actions/comparators"
    autoload :CsvImports, "coupler/api/actions/csv_imports"
    autoload :Datasets, "coupler/api/actions/datasets"
    autoload :Jobs, "coupler/api/actions/jobs"
    autoload :LinkageResults, "coupler/api/actions/linkage_results"
    autoload :Linkages, "coupler/api/actions/linkages"
    autoload :Migrations, "coupler/api/actions/migrations"
    autoload :DatasetExports, "coupler/api/actions/dataset_exports"

    # routers
    autoload :ComparatorRouter, "coupler/api/routers/comparator_router"
    autoload :CsvImportRouter, "coupler/api/routers/csv_import_router"
    autoload :DatasetRouter, "coupler/api/routers/dataset_router"
    autoload :JobRouter, "coupler/api/routers/job_router"
    autoload :LinkageResultRouter, "coupler/api/routers/linkage_result_router"
    autoload :LinkageRouter, "coupler/api/routers/linkage_router"
    autoload :MigrationRouter, "coupler/api/routers/migration_router"
    autoload :DatasetExportRouter, "coupler/api/routers/dataset_export_router"

    # controllers
    autoload :ComparatorController, "coupler/api/controllers/comparator_controller"
    autoload :CsvImportController, "coupler/api/controllers/csv_import_controller"
    autoload :DatasetController, "coupler/api/controllers/dataset_controller"
    autoload :JobController, "coupler/api/controllers/job_controller"
    autoload :LinkageController, "coupler/api/controllers/linkage_controller"
    autoload :LinkageResultController, "coupler/api/controllers/linkage_result_controller"
    autoload :MigrationController, "coupler/api/controllers/migration_controller"
    autoload :DatasetExportController, "coupler/api/controllers/dataset_export_controller"

    # params
    autoload :ComparatorParams, "coupler/api/params/comparator_params"
    autoload :CsvImportParams, "coupler/api/params/csv_import_params"
    autoload :DatasetParams, "coupler/api/params/dataset_params"
    autoload :JobParams, "coupler/api/params/job_params"
    autoload :LinkageParams, "coupler/api/params/linkage_params"
    autoload :LinkageResultParams, "coupler/api/params/linkage_result_params"
    autoload :MigrationParams, "coupler/api/params/migration_params"
    autoload :DatasetExportParams, "coupler/api/params/dataset_export_params"

    # validators
    autoload :ComparatorValidators, "coupler/api/validators/comparator_validators"
    autoload :CsvImportValidators, "coupler/api/validators/csv_import_validators"
    autoload :DatasetValidators, "coupler/api/validators/dataset_validators"
    autoload :JobValidators, "coupler/api/validators/job_validators"
    autoload :LinkageResultValidators, "coupler/api/validators/linkage_result_validators"
    autoload :LinkageValidators, "coupler/api/validators/linkage_validators"
    autoload :MigrationValidators, "coupler/api/validators/migration_validators"
    autoload :DatasetExportValidators, "coupler/api/validators/dataset_export_validators"

    # entities
    autoload :Comparator, "coupler/api/entities/comparator"
    autoload :CsvImport, "coupler/api/entities/csv_import"
    autoload :Dataset, "coupler/api/entities/dataset"
    autoload :Job, "coupler/api/entities/job"
    autoload :Linkage, "coupler/api/entities/linkage"
    autoload :LinkageResult, "coupler/api/entities/linkage_result"
    autoload :Migration, "coupler/api/entities/migration"
    autoload :DatasetExport, "coupler/api/entities/dataset_export"

    # combiners
    autoload :LinkageCombiner, "coupler/api/combiners/linkage_combiner"
    autoload :LinkageResultCombiner, "coupler/api/combiners/linkage_result_combiner"
    autoload :JobCombiner, "coupler/api/combiners/job_combiner"
    autoload :MigrationCombiner, "coupler/api/combiners/migration_combiner"

    # destroyers
    autoload :LinkageDestroyer, "coupler/api/destroyers/linkage_destroyer"

    # runners
    autoload :LinkageRunner, "coupler/api/runners/linkage_runner"
    autoload :MigrationRunner, "coupler/api/runners/migration_runner"
    autoload :LinkageResultExportRunner, "coupler/api/runners/linkage_result_export_runner"
    autoload :DatasetExportRunner, "coupler/api/runners/dataset_export_runner"

    # supervisors
    autoload :SpawnSupervisor, "coupler/api/supervisors/spawn_supervisor"
    autoload :ThreadSupervisor, "coupler/api/supervisors/thread_supervisor"

    # importers
    autoload :CSVImporter, "coupler/api/importers/csv_importer"

    def self.Entity(attribute_names, &block)
      klass = Class.new(Entity) do
        @attribute_names = attribute_names

        attribute_names.each do |attribute_name|
          define_method(attribute_name) do
            @attributes[attribute_name]
          end

          define_method("#{attribute_name}=") do |value|
            @attributes[attribute_name] = value
          end
        end
      end

      if block
        klass.module_eval(&block)
      end

      klass
    end
  end
end
