module CouplerAPI
  class DatasetController < Controller
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
      @index.run
    end

    def create(req, res)
      data = JSON.parse(req.body.read)
      params = @create_params.process(data)
      @create.run(params)
    end

    def update(req, res)
      data = JSON.parse(req.body.read)
      data['id'] = req['dataset_id']
      params = @update_params.process(data)
      @update.run(params)
    end

    def show(req, res)
      params = @show_params.process({ 'id' => req['dataset_id'] })
      @show.run(params)
    end

    def delete(req, res)
      params = @show_params.process({ 'id' => req['dataset_id'] })
      @delete.run(params)
    end

    def fields(req, res)
      params = @show_params.process({ 'id' => req['dataset_id'] })
      @fields.run(params)
    end
  end
end
