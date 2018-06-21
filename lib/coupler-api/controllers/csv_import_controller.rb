module CouplerAPI
  class CsvImportController < Controller
    def initialize(create, update, show, index, create_params, update_params, show_params)
      @create = create
      @update = update
      @show = show
      @index = index
      @create_params = create_params
      @update_params = update_params
      @show_params = show_params
    end

    def self.dependencies
      [ 'CsvImports::Create', 'CsvImports::Update', 'CsvImports::Show',
        'CsvImports::Index', 'CsvImportParams::Create',
        'CsvImportParams::Update', 'CsvImportParams::Show' ]
    end

    def create(req, res)
      data = JSON.parse(req.body.read)
      params = @create_params.process(data)
      @create.run(params)
    end

    def update(req, res)
      data = JSON.parse(req.body.read)
      params = @update_params.process(data)
      @update.run(params)
    end

    def show(req, res)
      data = { 'id' => req['id'] }
      if req.params.has_key?('row_count')
        data['row_count'] = req.params['row_count']
      end
      params = @show_params.process(data)
      @show.run(params)
    end

    def index(req, res)
      @index.run
    end
  end
end
