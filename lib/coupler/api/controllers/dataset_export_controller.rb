module Coupler::API
  class DatasetExportController < Controller
    def initialize(show, download, show_params, download_params)
      @show = show
      @download = download
      @show_params = show_params
      @download_params = download_params
    end

    def self.dependencies
      [ 'DatasetExports::Show', 'DatasetExports::Download',
        'DatasetExportParams::Show', 'DatasetExportParams::Download' ]
    end

    def show(req, res)
      data = { 'id' => req['dataset_export_id'] }
      params = @show_params.process(data)
      @show.run(params)
    end

    def download(req, res)
      data = { 'id' => req['id'] }
      params = @download_params.process(data)
      @download.run(params)
    end
  end
end
