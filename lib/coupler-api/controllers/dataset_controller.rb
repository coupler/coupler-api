module CouplerAPI
  class DatasetController < Controller
    def initialize(index, create, update, show, delete, fields, records,
                   count_records, index_params, create_params, update_params,
                   show_params, records_params, count_records_params)
      @index = index
      @create = create
      @update = update
      @show = show
      @delete = delete
      @fields = fields
      @records = records
      @count_records = count_records
      @index_params = index_params
      @create_params = create_params
      @update_params = update_params
      @show_params = show_params
      @records_params = records_params
      @count_records_params = count_records_params
    end

    def self.dependencies
      [
        'Datasets::Index', 'Datasets::Create', 'Datasets::Update',
        'Datasets::Show', 'Datasets::Delete', 'Datasets::Fields',
        'Datasets::Records', 'Datasets::CountRecords', 'DatasetParams::Index',
        'DatasetParams::Create', 'DatasetParams::Update',
        'DatasetParams::Show', 'DatasetParams::Records',
        'DatasetParams::CountRecords'
      ]
    end

    def index(req, res)
      data = {}
      if req.params.has_key?('include_fields')
        data['include_fields'] = req.params['include_fields']
      end
      params = @index_params.process(data)
      @index.run(params)
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
      data = { 'id' => req['dataset_id'] }
      if req.params.has_key?('include_fields')
        data['include_fields'] = req.params['include_fields']
      end
      params = @show_params.process(data)
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

    def records(req, res)
      params = @records_params.process({
        'id' => req['dataset_id'],
        'limit' => req.params['limit'],
        'offset' => req.params['offset']
      })
      @records.run(params)
    end

    def count_records(req, res)
      params = @count_records_params.process({
        'id' => req['dataset_id']
      })
      @count_records.run(params)
    end
  end
end
