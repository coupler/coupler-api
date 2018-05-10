module CouplerAPI
  class CsvImportController < Controller
    def initialize(create, show, create_params, show_params)
      @create = create
      @show = show
      @create_params = create_params
      @show_params = show_params
    end

    def self.dependencies
      [ 'CsvImports::Create', 'CsvImports::Show', 'CsvImportParams::Create',
        'CsvImportParams::Show' ]
    end

    def create(req, res)
      data = JSON.parse(req.body.read)
      params = @create_params.process(data)
      @create.run(params)
    end

    def show(req, res)
      data = { 'id' => req['dataset_id'] }
      params = @show_params.process(data)
      @show.run(params)
    end
  end
end
