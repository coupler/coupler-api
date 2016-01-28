module Coupler
  module API
    class CLI < Thor
      desc "start", "Run coupler-api"
      option :server, :type => :string, :default => 'webrick', :desc => "HTTP server to use"
      option :port, :type => :numeric, :default => 4567, :desc => "Port to use for HTTP server"
      option :adapter, :type => :string, :default => 'sqlite', :desc => "Database adapter to use for storage"
      option :database, :type => :string, :default => 'coupler-api.db', :desc => "Database path or name"

      def start
        injector = Injector.new
        bootstrap(injector, options)

        # run migrations
        adapter = injector.get('adapter');
        adapter.migrate(File.join(File.dirname(__FILE__), '..', '..', '..', 'migrate'))

        app = Application.new([
          { path: %r{^/datasets(?=/)?}, router: injector.get('DatasetRouter') }
        ])
        builder = Rack::Builder.new(app) do
          use Rack::Cors do
            allow do
              origins 'localhost:12345'
              resource '*', :methods => :any, :headers => :any
            end
          end
        end
        Rack::Handler::WEBrick.run(builder, { Port: options[:port] })
      end

      private

      def bootstrap(injector, options)
        injector.register_factory('adapter', lambda {
          SequelAdapter.new({
            adapter: options[:adapter],
            database: options[:database]
          })
        })
        injector.register_service('DatasetRepository', DatasetRepository)
        injector.register_service('DatasetRouter', DatasetRouter)
        injector.register_service('DatasetController', DatasetController)
        injector.register_service('Datasets::Index', Datasets::Index)
        injector.register_service('Datasets::Create', Datasets::Create)
        injector.register_service('Datasets::Show', Datasets::Show)
        injector.register_service('Datasets::Delete', Datasets::Delete)
      end
    end
  end
end
