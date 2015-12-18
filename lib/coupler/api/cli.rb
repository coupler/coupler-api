module Coupler
  module API
    class CLI < Thor
      desc "start", "Run coupler-api"
      option :server, :type => :string, :default => 'webrick', :desc => "HTTP server to use"
      option :port, :type => :numeric, :default => 4567, :desc => "Port to use for HTTP server"
      option :adapter, :type => :string, :default => 'sqlite', :desc => "Database adapter to use for storage"
      option :database, :type => :string, :desc => "Database path or name"

      def start
        app = Coupler::API::Application.new(options)
        Rack::Handler::WEBrick.run(app, { Port: options[:port] })
      end
    end
  end
end
