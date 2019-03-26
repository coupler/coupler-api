module Coupler::API
  class LinkageController < Controller
    def initialize(index, create, update, show, delete, comparators, create_params, update_params, show_params)
      @index = index
      @create = create
      @update = update
      @show = show
      @delete = delete
      @comparators = comparators
      @create_params = create_params
      @update_params = update_params
      @show_params = show_params
    end

    def self.dependencies
      [
        'Linkages::Index', 'Linkages::Create', 'Linkages::Update',
        'Linkages::Show', 'Linkages::Delete', 'Linkages::Comparators',
        'LinkageParams::Create', 'LinkageParams::Update', 'LinkageParams::Show'
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
      data['id'] = req['linkage_id']
      params = @update_params.process(data)
      @update.run(params)
    end

    def show(req, res)
      params = @show_params.process({ 'id' => req['linkage_id'] })
      @show.run(params)
    end

    def delete(req, res)
      params = @show_params.process({ 'id' => req['linkage_id'] })
      @delete.run(params)
    end

    def comparators(req, res)
      params = @show_params.process({ 'id' => req['linkage_id'] })
      @comparators.run(params)
    end
  end
end
