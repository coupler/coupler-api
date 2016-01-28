module Coupler
  module API
    class DatasetController
      def initialize(index, create, show, delete)
        @index = index
        @create = create
        @show = show
        @delete = delete
      end

      def self.dependencies
        ['Datasets::Index', 'Datasets::Create', 'Datasets::Show', 'Datasets::Delete']
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

      def show(req, res)
        params = ShowParams.new({ 'id' => req['dataset_id'] })
        result = @show.run(params)
        if result
          JSON.generate(result)
        end
      end

      def delete(req, res)
        params = ShowParams.new({ 'id' => req['dataset_id'] })
        result = @delete.run(params)
        if result
          JSON.generate(result)
        end
      end
    end
  end
end
