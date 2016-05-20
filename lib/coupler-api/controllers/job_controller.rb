module CouplerAPI
  class JobController
    def initialize(create, show, linkage, create_params, show_params, linkage_params)
      @create = create
      @show = show
      @linkage = linkage
      @create_params = create_params
      @show_params = show_params
      @linkage_params = linkage_params
    end

    def self.dependencies
      [
        'Jobs::Create', 'Jobs::Show', 'Jobs::Linkage', 'JobParams::Create',
        'JobParams::Show', 'JobParams::Linkage'
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

    def linkage(req, res)
      params = @linkage_params.process({ 'id' => req['job_id'] })
      result = @linkage.run(params)
      if result
        JSON.generate(result)
      end
    end
  end
end
