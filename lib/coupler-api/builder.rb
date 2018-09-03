module CouplerAPI
  class Builder
    attr_reader :injector, :options

    def initialize(options)
      @options = options.dup
      @options["database_uri"] ||=
        (RUBY_PLATFORM == "java" ? "jdbc:sqlite:" : "sqlite://") +
        File.join(@options["storage_path"], "coupler-api.db")
      @options["supervisor_style"] ||= "spawn"
      @injector = Injector.new
      bootstrap
    end

    def app
      app = injector.get("Application")
      Rack::Builder.new(app) do
        use Rack::Cors do
          allow do
            origins 'localhost:4200'
            resource '*', :methods => :any, :headers => :any
          end
        end
        use Rack::CommonLogger
      end
    end

    def supervisor
      injector.get("Supervisor")
    end

    def runner
      injector.get("Runner")
    end

    private

    def bootstrap
      injector.register_value('storage_path', @options["storage_path"])
      injector.register_value('database_uri', @options["database_uri"])
      injector.register_factory('adapter', method(:create_adapter))

      injector.register_service('Application', Application)

      injector.register_service('DatasetRepository', DatasetRepository)
      injector.register_service('DatasetRouter', DatasetRouter)
      injector.register_service('DatasetController', DatasetController)
      injector.register_service('Datasets::Index', Datasets::Index)
      injector.register_service('Datasets::Create', Datasets::Create)
      injector.register_service('Datasets::Update', Datasets::Update)
      injector.register_service('Datasets::Show', Datasets::Show)
      injector.register_service('Datasets::Delete', Datasets::Delete)
      injector.register_service('Datasets::Fields', Datasets::Fields)
      injector.register_service('Datasets::Records', Datasets::Records)
      injector.register_service('Datasets::CountRecords', Datasets::CountRecords)
      injector.register_service('DatasetParams::Index', DatasetParams::Index)
      injector.register_service('DatasetParams::Create', DatasetParams::Create)
      injector.register_service('DatasetParams::Update', DatasetParams::Update)
      injector.register_service('DatasetParams::Show', DatasetParams::Show)
      injector.register_service('DatasetParams::Records', DatasetParams::Records)
      injector.register_service('DatasetParams::CountRecords', DatasetParams::CountRecords)
      injector.register_service('DatasetValidators::Index', DatasetValidators::Index)
      injector.register_service('DatasetValidators::Create', DatasetValidators::Create)
      injector.register_service('DatasetValidators::Update', DatasetValidators::Update)
      injector.register_service('DatasetValidators::Show', DatasetValidators::Show)
      injector.register_service('DatasetValidators::Records', DatasetValidators::Records)
      injector.register_service('DatasetValidators::CountRecords', DatasetValidators::CountRecords)

      injector.register_service('LinkageRepository', LinkageRepository)
      injector.register_service('LinkageCombiner', LinkageCombiner)
      injector.register_service('LinkageDestroyer', LinkageDestroyer)
      injector.register_service('LinkageRouter', LinkageRouter)
      injector.register_service('LinkageController', LinkageController)
      injector.register_service('Linkages::Index', Linkages::Index)
      injector.register_service('Linkages::Create', Linkages::Create)
      injector.register_service('Linkages::Update', Linkages::Update)
      injector.register_service('Linkages::Show', Linkages::Show)
      injector.register_service('Linkages::Delete', Linkages::Delete)
      injector.register_service('Linkages::Comparators', Linkages::Comparators)
      injector.register_service('LinkageParams::Create', LinkageParams::Create)
      injector.register_service('LinkageParams::Update', LinkageParams::Update)
      injector.register_service('LinkageParams::Show', LinkageParams::Show)
      injector.register_service('LinkageValidators::Create', LinkageValidators::Create)
      injector.register_service('LinkageValidators::Update', LinkageValidators::Update)
      injector.register_service('LinkageValidators::Show', LinkageValidators::Show)

      injector.register_service('ComparatorRepository', ComparatorRepository)
      injector.register_service('ComparatorRouter', ComparatorRouter)
      injector.register_service('ComparatorController', ComparatorController)
      injector.register_service('Comparators::Index', Comparators::Index)
      injector.register_service('Comparators::Create', Comparators::Create)
      injector.register_service('Comparators::Update', Comparators::Update)
      injector.register_service('Comparators::Show', Comparators::Show)
      injector.register_service('Comparators::Delete', Comparators::Delete)
      injector.register_service('ComparatorParams::Create', ComparatorParams::Create)
      injector.register_service('ComparatorParams::Update', ComparatorParams::Update)
      injector.register_service('ComparatorParams::Show', ComparatorParams::Show)
      injector.register_service('ComparatorValidators::Create', ComparatorValidators::Create)
      injector.register_service('ComparatorValidators::Update', ComparatorValidators::Update)
      injector.register_service('ComparatorValidators::Show', ComparatorValidators::Show)

      injector.register_service('JobRepository', JobRepository)
      injector.register_service('JobCombiner', JobCombiner)
      injector.register_service('JobRouter', JobRouter)
      injector.register_service('JobController', JobController)
      injector.register_service('Jobs::Index', Jobs::Index)
      injector.register_service('Jobs::Create', Jobs::Create)
      injector.register_service('Jobs::Show', Jobs::Show)
      injector.register_service('JobParams::Create', JobParams::Create)
      injector.register_service('JobParams::Show', JobParams::Show)
      injector.register_service('JobValidators::Create', JobValidators::Create)
      injector.register_service('JobValidators::Show', JobValidators::Show)

      injector.register_service('LinkageResultRepository', LinkageResultRepository)
      injector.register_service('LinkageResultRouter', LinkageResultRouter)
      injector.register_service('LinkageResultController', LinkageResultController)
      injector.register_service('LinkageResults::Show', LinkageResults::Show)
      injector.register_service('LinkageResults::Matches', LinkageResults::Matches)
      injector.register_service('LinkageResultParams::Show', LinkageResultParams::Show)
      injector.register_service('LinkageResultParams::Matches', LinkageResultParams::Matches)
      injector.register_service('LinkageResultValidators::Show', LinkageResultValidators::Show)
      injector.register_service('LinkageResultValidators::Matches', LinkageResultValidators::Matches)

      injector.register_service('CsvImportRepository', CsvImportRepository)
      injector.register_service('CsvImportRouter', CsvImportRouter)
      injector.register_service('CsvImportController', CsvImportController)
      injector.register_service('CsvImports::Create', CsvImports::Create)
      injector.register_service('CsvImports::Update', CsvImports::Update)
      injector.register_service('CsvImports::Show', CsvImports::Show)
      injector.register_service('CsvImports::Index', CsvImports::Index)
      injector.register_service('CsvImportParams::Create', CsvImportParams::Create)
      injector.register_service('CsvImportParams::Update', CsvImportParams::Update)
      injector.register_service('CsvImportParams::Show', CsvImportParams::Show)
      injector.register_service('CsvImportValidators::Create', CsvImportValidators::Create)
      injector.register_service('CsvImportValidators::Update', CsvImportValidators::Update)
      injector.register_service('CsvImportValidators::Show', CsvImportValidators::Show)

      injector.register_service('MigrationRepository', MigrationRepository)
      injector.register_service('MigrationRouter', MigrationRouter)
      injector.register_service('MigrationController', MigrationController)
      injector.register_service('Migrations::Create', Migrations::Create)
      injector.register_service('MigrationParams::Create', MigrationParams::Create)
      injector.register_service('MigrationValidators::Create', MigrationValidators::Create)

      injector.register_service('Runner', Runner)
      injector.register_service('LinkageRunner', LinkageRunner)

      injector.register_service('CSVImporter', CSVImporter)

      case @options["supervisor_style"]
      when "spawn"
        injector.register_service('Supervisor', SpawnSupervisor)
      when "thread"
        injector.register_service('Supervisor', ThreadSupervisor)
      else
        raise "Unknown supervisor type: #{@options["supervisor_style"]}"
      end
    end

    def create_adapter
      adapter = SequelAdapter.new(@options["database_uri"])
      adapter.migrate(File.expand_path(File.join(File.dirname(__FILE__), '..', '..', 'db', 'migrate')))
      adapter
    end
  end
end
