module Coupler::API
  class CsvImportController < Controller
    def initialize(create, update, show, index, download, create_params, update_params, show_params, download_params)
      @create = create
      @update = update
      @show = show
      @index = index
      @download = download
      @create_params = create_params
      @update_params = update_params
      @show_params = show_params
      @download_params = download_params
    end

    def self.dependencies
      [ 'CsvImports::Create', 'CsvImports::Update', 'CsvImports::Show',
        'CsvImports::Index', 'CsvImports::Download', 'CsvImportParams::Create',
        'CsvImportParams::Update', 'CsvImportParams::Show',
        'CsvImportParams::Download' ]
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

    def download(req, res)
      data = { 'id' => req['id'] }
      params = @download_params.process(data)
      @download.run(params)
    end

    def index(req, res)
      @index.run
    end

    def build_action(name)
      action = method(name.to_sym || :not_found)
      lambda do |req, res|
        result = action.call(req, res)
        if result.is_a?(Hash)
          if result.has_key?('errors')
            if res.status == 200
              res.status = 400
            end
          elsif result.has_key?('_download')
            # Download file instead of handling result as json
            #
            # NOTE: this is a naive implementation, since it reads the entire
            # file into memory at once
            params = result['_download']
            res["Content-Type"] = params['content_type']
            res["Content-Disposition"] = "attachment; filename=" +
              params['filename'].inspect
            res.write(File.read(params['path']))
            return
          end
        end
        res["Content-Type"] = "application/json"
        res.write(JSON.generate(result))
      end
    end
  end
end
