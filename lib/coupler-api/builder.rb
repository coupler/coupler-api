module CouplerAPI
  class Builder
    def self.create(options)
      builder = new(options)
      builder.create
    end

    attr_reader :injector, :options

    def initialize(options)
      @options = options
      @injector = Injector.new
    end

    def create
      bootstrap

      routes = create_routes(injector)
      app = Application.new(routes)
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

    private

    def bootstrap
      injector.register_value('storage_path', @options[:storage_path])
      injector.register_factory('adapter', method(:create_adapter))

      injector.register_service('DatasetRepository', DatasetRepository)
      injector.register_service('DatasetRouter', DatasetRouter)
      injector.register_service('DatasetController', DatasetController)
      injector.register_service('Datasets::Index', Datasets::Index)
      injector.register_service('Datasets::Create', Datasets::Create)
      injector.register_service('Datasets::Update', Datasets::Update)
      injector.register_service('Datasets::Show', Datasets::Show)
      injector.register_service('Datasets::Delete', Datasets::Delete)
      injector.register_service('Datasets::Fields', Datasets::Fields)
      injector.register_service('DatasetParams::Create', DatasetParams::Create)
      injector.register_service('DatasetParams::Update', DatasetParams::Update)
      injector.register_service('DatasetParams::Show', DatasetParams::Show)
      injector.register_service('DatasetValidators::Create', DatasetValidators::Create)
      injector.register_service('DatasetValidators::Update', DatasetValidators::Update)
      injector.register_service('DatasetValidators::Show', DatasetValidators::Show)

      injector.register_service('LinkageRepository', LinkageRepository)
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
      injector.register_service('JobRouter', JobRouter)
      injector.register_service('JobController', JobController)
      injector.register_service('Jobs::Create', Jobs::Create)
      injector.register_service('Jobs::Show', Jobs::Show)
      injector.register_service('Jobs::Linkage', Jobs::Linkage)
      injector.register_service('JobParams::Create', JobParams::Create)
      injector.register_service('JobParams::Show', JobParams::Show)
      injector.register_service('JobParams::Linkage', JobParams::Linkage)
      injector.register_service('JobValidators::Create', JobValidators::Create)
      injector.register_service('JobValidators::Show', JobValidators::Show)
      injector.register_service('JobValidators::Linkage', JobValidators::Linkage)

      injector.register_service('LinkageCombiner', LinkageCombiner)
    end

    def create_adapter
      adapter = SequelAdapter.new(@options[:uri])
      adapter.migrate(File.expand_path(File.join(File.dirname(__FILE__), '..', '..', 'db', 'migrate')))
      adapter
    end

    def create_routes(injector)
      [
        { path: %r{^/datasets(?=/)?}, router: injector.get('DatasetRouter') },
        { path: %r{^/linkages(?=/)?}, router: injector.get('LinkageRouter') },
        { path: %r{^/comparators(?=/)?}, router: injector.get('ComparatorRouter') },
        { path: %r{^/jobs(?=/)?}, router: injector.get('JobRouter') },
      ]
    end
  end
end
