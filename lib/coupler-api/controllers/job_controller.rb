module CouplerAPI
  class JobController
    def initialize(create, show, linkage)
      @create = create
      @show = show
      @linkage = linkage
    end

    def self.dependencies
      ['Jobs::Create', 'Jobs::Show', 'Jobs::Linkage']
    end

    def create(req, res)
      data = JSON.parse(req.body.read)
      params = JobParams::Create.process(data)
      result = @create.run(params)
      JSON.generate(result)
    end

    def show(req, res)
      params = JobParams::Show.process({ 'id' => req['job_id'] })
      result = @show.run(params)
      if result
        JSON.generate(result)
      end
    end

    def linkage(req, res)
      params = JobParams::Linkage.process({ 'id' => req['job_id'] })
      result = @linkage.run(params)
      if result
        JSON.generate(result)
      end
    end
  end
end
