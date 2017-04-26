module CouplerAPI
  class JobController < Controller
    def initialize(create, show, run, create_params, show_params, run_params)
      @create = create
      @show = show
      @run = run
      @create_params = create_params
      @show_params = show_params
      @run_params = run_params
    end

    def self.dependencies
      [
        'Jobs::Create', 'Jobs::Show', 'Jobs::Run', 'JobParams::Create',
        'JobParams::Show', 'JobParams::Run'
      ]
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
