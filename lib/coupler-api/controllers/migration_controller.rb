module CouplerAPI
  class MigrationController < Controller
    def initialize(create, create_params)
      @create = create
      @create_params = create_params
    end

    def self.dependencies
      [ 'Migrations::Create', 'MigrationParams::Create' ]
    end

    def create(req, res)
      data = JSON.parse(req.body.read)
      params = @create_params.process(data)
      @create.run(params)
    end
  end
end
