module CouplerAPI
  class ComparatorController
    def initialize(index, create, update, show, delete)
      @index = index
      @create = create
      @update = update
      @show = show
      @delete = delete
    end

    def self.dependencies
      ['Comparators::Index', 'Comparators::Create', 'Comparators::Update', 'Comparators::Show', 'Comparators::Delete']
    end

    def index(req, res)
      result = @index.run
      JSON.generate(result)
    end

    def create(req, res)
      data = JSON.parse(req.body.read)
      params = ComparatorParams::Create.process(data)
      result = @create.run(params)
      JSON.generate(result)
    end

    def update(req, res)
      data = JSON.parse(req.body.read)
      data['id'] = req['comparator_id']
      params = ComparatorParams::Update.process(data)
      result = @update.run(params)
      JSON.generate(result)
    end

    def show(req, res)
      params = ComparatorParams::Show.process({ 'id' => req['comparator_id'] })
      result = @show.run(params)
      if result
        JSON.generate(result)
      end
    end

    def delete(req, res)
      params = ComparatorParams::Show.process({ 'id' => req['comparator_id'] })
      result = @delete.run(params)
      if result
        JSON.generate(result)
      end
    end
  end
end
