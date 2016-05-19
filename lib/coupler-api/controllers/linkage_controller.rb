module CouplerAPI
  class LinkageController
    def initialize(index, create, update, show, delete, comparators)
      @index = index
      @create = create
      @update = update
      @show = show
      @delete = delete
      @comparators = comparators
    end

    def self.dependencies
      ['Linkages::Index', 'Linkages::Create', 'Linkages::Update', 'Linkages::Show', 'Linkages::Delete', 'Linkages::Comparators']
    end

    def index(req, res)
      result = @index.run
      JSON.generate(result)
    end

    def create(req, res)
      data = JSON.parse(req.body.read)
      params = LinkageParams::Create.process(data)
      result = @create.run(params)
      JSON.generate(result)
    end

    def update(req, res)
      data = JSON.parse(req.body.read)
      data['id'] = req['linkage_id']
      params = LinkageParams::Update.process(data)
      result = @update.run(params)
      JSON.generate(result)
    end

    def show(req, res)
      params = LinkageParams::Show.process({ 'id' => req['linkage_id'] })
      result = @show.run(params)
      if result
        JSON.generate(result)
      end
    end

    def delete(req, res)
      params = LinkageParams::Show.process({ 'id' => req['linkage_id'] })
      result = @delete.run(params)
      if result
        JSON.generate(result)
      end
    end

    def comparators(req, res)
      params = LinkageParams::Show.process({ 'id' => req['linkage_id'] })
      result = @comparators.run(params)
      if result
        JSON.generate(result)
      end
    end
  end
end
