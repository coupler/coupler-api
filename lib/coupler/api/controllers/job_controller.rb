module Coupler
  module API
    class JobController
      def initialize(create)
        @create = create
      end

      def self.dependencies
        ['Jobs::Create']
      end

      def create(req, res)
        data = JSON.parse(req.body.read)
        params = JobParams::Create.process(data)
        result = @create.run(params)
        JSON.generate(result)
      end
    end
  end
end
