module Coupler
  module API
    class JobController
      def initialize(create, show)
        @create = create
        @show = show
      end

      def self.dependencies
        ['Jobs::Create', 'Jobs::Show']
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
    end
  end
end
