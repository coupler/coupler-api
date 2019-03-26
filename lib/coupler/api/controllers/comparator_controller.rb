module Coupler::API
  class ComparatorController < Controller
    def initialize(index, create, update, show, delete, create_params, update_params, show_params)
      @index = index
      @create = create
      @update = update
      @show = show
      @delete = delete
      @create_params = create_params
      @update_params = update_params
      @show_params = show_params
    end

    def self.dependencies
      [
        'Comparators::Index', 'Comparators::Create', 'Comparators::Update',
        'Comparators::Show', 'Comparators::Delete', 'ComparatorParams::Create',
        'ComparatorParams::Update', 'ComparatorParams::Show'
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
      data['id'] = req['comparator_id']
      params = @update_params.process(data)
      @update.run(params)
    end

    def show(req, res)
      params = @show_params.process({ 'id' => req['comparator_id'] })
      @show.run(params)
    end

    def delete(req, res)
      params = @show_params.process({ 'id' => req['comparator_id'] })
      @delete.run(params)
    end
  end
end
