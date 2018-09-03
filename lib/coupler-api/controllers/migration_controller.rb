module CouplerAPI
  class MigrationController < Controller
    def initialize(create, show, create_params, show_params)
      @create = create
      @show = show
      @create_params = create_params
      @show_params = show_params
    end

    def self.dependencies
      [ 'Migrations::Create', 'Migrations::Show', 'MigrationParams::Create',
        'MigrationParams::Show' ]
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
  end
end
