module Coupler::API
  class MigrationController < Controller
    def initialize(create, show, index, create_params, show_params, index_params)
      @create = create
      @show = show
      @index = index
      @create_params = create_params
      @show_params = show_params
      @index_params = index_params
    end

    def self.dependencies
      [ 'Migrations::Create', 'Migrations::Show', 'Migrations::Index',
        'MigrationParams::Create', 'MigrationParams::Show',
        'MigrationParams::Index' ]
    end

    def create(req, res)
      data = JSON.parse(req.body.read)
      params = @create_params.process(data)
      @create.run(params)
    end

    def show(req, res)
      data = { 'id' => req['migration_id'] }
      params = @show_params.process(data)
      @show.run(params)
    end

    def index(req, res)
      params = @index_params.process({})
      @index.run(params)
    end
  end
end
