module CouplerAPI
  class JobController
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
      result = @create.run(params)
      JSON.generate(result)
    end

    def show(req, res)
      params = @show_params.process({ 'id' => req['job_id'] })
      result = @show.run(params)
      if result
        JSON.generate(result)
      end
    end

    def run(req, res)
      params = @run_params.process({ 'id' => req['job_id'] })
      result = @run.run(params)
      if result
        JSON.generate(result)
      end
    end
  end
end
