module Coupler
  module API
    class CLI < Thor
      desc "start", "Run coupler-api"
      option :server, :type => :string, :default => 'webrick', :desc => "HTTP server to use"
      option :port, :type => :numeric, :default => 4567, :desc => "Port to use for HTTP server"
      option :adapter, :type => :string, :default => 'sql', :desc => "Database adapter to use for storage"
      option :uri, :type => :string, :default => 'sqlite://coupler-api.db', :desc => "Database URI"
      option :result_path, :type => :string, :desc => "Directory for result sets", :required => true

      def start
        app = Builder.create(options)
        Rack::Handler::WEBrick.run(app, { Port: options[:port] })
      end
    end
  end
end
