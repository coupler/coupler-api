module CouplerAPI
  class JobController < Controller
    def initialize(index, create, show, run, create_params, show_params, run_params)
      @index = index
      @create = create
      @show = show
      @run = run
      @create_params = create_params
      @show_params = show_params
      @run_params = run_params
    end

    def self.dependencies
      [
        'Jobs::Index', 'Jobs::Create', 'Jobs::Show', 'Jobs::Run',
        'JobParams::Create', 'JobParams::Show', 'JobParams::Run'
      ]
    end

    def index(req, res)
      @index.run
    end

    def create(req, res)
      data = JSON.parse(req.body.read)
      params = @create_params.process(data)
      @create.run(params)
    end

    def show(req, res)
      params = @show_params.process({ 'id' => req['job_id'] })
      @show.run(params)
    end

    def run(req, res)
      params = @run_params.process({ 'id' => req['job_id'] })
      @run.run(params)
    end
  end
end
