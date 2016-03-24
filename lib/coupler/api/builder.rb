module Coupler
  module API
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
              origins 'localhost:12345'
              resource '*', :methods => :any, :headers => :any
            end
          end
        end
      end

      private

      def bootstrap
        injector.register_factory('container', method(:create_container))

        injector.register_service('DatasetRepository', DatasetRepository)
        injector.register_service('DatasetRouter', DatasetRouter)
        injector.register_service('DatasetController', DatasetController)
        injector.register_service('Datasets::Index', Datasets::Index)
        injector.register_service('Datasets::Create', Datasets::Create)
        injector.register_service('Datasets::Update', Datasets::Update)
        injector.register_service('Datasets::Show', Datasets::Show)
        injector.register_service('Datasets::Delete', Datasets::Delete)
        injector.register_service('Datasets::Fields', Datasets::Fields)

        injector.register_service('LinkageRepository', LinkageRepository)
        injector.register_service('LinkageRouter', LinkageRouter)
        injector.register_service('LinkageController', LinkageController)
        injector.register_service('Linkages::Create', Linkages::Create)
        injector.register_service('Linkages::Show', Linkages::Show)
      end

      def create_container
        config = ROM::Configuration.new(options[:adapter].to_sym, options[:uri])
        config.use(:macros)

        config.relation(:datasets) do
          def by_id(id)
            where(id: id)
          end
        end
        config.commands(:datasets) do
          define(:create)
          define(:update)
          define(:delete)
        end

        config.relation(:linkages) do
          def by_id(id)
            where(id: id)
          end
        end
        config.commands(:linkages) do
          define(:create)
          define(:update)
          define(:delete)
        end

        container = ROM.container(config)

        # run migrations
        gateway = container.gateways[:default]
        gateway.run_migrations

        container
      end

      def create_routes(injector)
        [
          { path: %r{^/datasets(?=/)?}, router: injector.get('DatasetRouter') },
          { path: %r{^/linkages(?=/)?}, router: injector.get('LinkageRouter') },
        ]
      end
    end
  end
end
