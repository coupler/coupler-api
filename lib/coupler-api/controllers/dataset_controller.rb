module CouplerAPI
  class DatasetController
    def initialize(index, create, update, show, delete, fields, create_params, update_params, show_params)
      @index = index
      @create = create
      @update = update
      @show = show
      @delete = delete
      @fields = fields
      @create_params = create_params
      @update_params = update_params
      @show_params = show_params
    end

    def self.dependencies
      [
        'Datasets::Index', 'Datasets::Create', 'Datasets::Update',
        'Datasets::Show', 'Datasets::Delete', 'Datasets::Fields',
        'DatasetParams::Create', 'DatasetParams::Update', 'DatasetParams::Show'
      ]
    end

    def index(req, res)
      result = @index.run
      JSON.generate(result)
    end

    def create(req, res)
      data = JSON.parse(req.body.read)
      params = @create_params.process(data)
      result = @create.run(params)
      JSON.generate(result)
    end

    def update(req, res)
      data = JSON.parse(req.body.read)
      data['id'] = req['dataset_id']
      params = @update_params.process(data)
      result = @update.run(params)
      JSON.generate(result)
    end

    def show(req, res)
      params = @show_params.process({ 'id' => req['dataset_id'] })
      result = @show.run(params)
      if result
        JSON.generate(result)
      end
    end

    def delete(req, res)
      params = @show_params.process({ 'id' => req['dataset_id'] })
      result = @delete.run(params)
      if result
        JSON.generate(result)
      end
    end

    def fields(req, res)
      params = @show_params.process({ 'id' => req['dataset_id'] })
      result = @fields.run(params)
      if result
        JSON.generate(result)
      end
    end
  end
end
