module CouplerAPI
  class ComparatorController
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
      result = @index.run
      JSON.generate(result)
    end

    def create(req, res)
      data = JSON.parse(req.body.read)
      params = @create_params.process(data)
      result = @create.run(params)
      JSON.generate(result)
    end

    def update(req, res)
      data = JSON.parse(req.body.read)
      data['id'] = req['comparator_id']
      params = @update_params.process(data)
      result = @update.run(params)
      JSON.generate(result)
    end

    def show(req, res)
      params = @show_params.process({ 'id' => req['comparator_id'] })
      result = @show.run(params)
      if result
        JSON.generate(result)
      end
    end

    def delete(req, res)
      params = @show_params.process({ 'id' => req['comparator_id'] })
      result = @delete.run(params)
      if result
        JSON.generate(result)
      end
    end
  end
end
