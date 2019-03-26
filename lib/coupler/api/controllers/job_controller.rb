module Coupler::API
  class JobController < Controller
    def initialize(index, create, show, create_params, show_params)
      @index = index
      @create = create
      @show = show
      @create_params = create_params
      @show_params = show_params
    end

    def self.dependencies
      [
        'Jobs::Index', 'Jobs::Create', 'Jobs::Show',
        'JobParams::Create', 'JobParams::Show',
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
  end
end
