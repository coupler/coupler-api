module Coupler
  module API
    class DatasetController
      def initialize(index, create)
        @index = index
        @create = create
      end

      def self.dependencies
        ['Datasets::Index', 'Datasets::Create']
      end

      def index(req, res)
        result = @index.run
        JSON.generate(result)
      end

      def create(req, res)
        data = JSON.parse(req.body.read)
        params = DatasetParams.new(data)
        result = @create.run(params)
        JSON.generate(result)
      end
    end
  end
end
