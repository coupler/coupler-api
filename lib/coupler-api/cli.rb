module CouplerAPI
  class CLI < Thor
    desc "start", "Run coupler-api"
    option :server, :type => :string, :default => 'webrick', :desc => "HTTP server to use"
    option :port, :type => :numeric, :default => 4567, :desc => "Port to use for HTTP server"
    option :storage_path, :type => :string, :desc => "Directory for storing files", :required => true
    option :database_uri, :type => :string, :desc => "Database URI"

    def start
      builder = Builder.new(options.to_hash)
      background = builder.background
      background.start
      Rack::Handler::WEBrick.run(builder.app, { Port: options[:port] }) do |server|
        Signal.trap("INT") do
          puts "Shutting down server..."
          server.shutdown

          puts "Waiting for jobs to finish..."
          background.stop
        end
      end
    end

    desc "job JOB_ID", "Run job"
    option :storage_path, :type => :string, :desc => "Directory for storing files", :required => true
    option :database_uri, :type => :string, :desc => "Database URI"

    def job(job_id)
      builder = Builder.new(options.to_hash)
      runner = builder.runner
      runner.run(job_id)
    end
  end
end
