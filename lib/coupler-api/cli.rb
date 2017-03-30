module CouplerAPI
  class CLI < Thor
    desc "start", "Run coupler-api"
    option :server, :type => :string, :default => 'webrick', :desc => "HTTP server to use"
    option :port, :type => :numeric, :default => 4567, :desc => "Port to use for HTTP server"
    option :storage_path, :type => :string, :desc => "Directory for storing files", :required => true
    option :uri, {
      :type => :string,
      :default => "#{RUBY_PLATFORM == "java" ? "jdbc:sqlite" : "sqlite"}://coupler-api.db",
      :desc => "Database URI"
    }

    def start
      app = Builder.create(options)
      Rack::Handler::WEBrick.run(app, { Port: options[:port] }) do |server|
        Signal.trap("INT") do
          server.shutdown
        end
      end
    end
  end
end
