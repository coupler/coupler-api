module CouplerAPI
  class DatasetRepository < ROM::Repository
    relations :datasets

    def self.dependencies
      ['container']
    end

    def initialize(env, options = {})
      super
      @create = env.commands[:datasets][:create]
      @update = env.commands[:datasets][:update]
      @delete = env.commands[:datasets][:delete]
    end

    def find
      datasets.to_a.collect do |obj|
        instantiate(obj)
      end
    end

    def first(conditions)
      obj = datasets.where(conditions).one
      instantiate(obj)
    end

    def create(data)
      obj = @create.call([data]).one
      instantiate(obj)
    end

    def update(id, data)
      @update.by_id(id).call(data).length
    end

    def delete(id)
      @delete.by_id(id).call.length
    end

    private

    def instantiate(obj)
      if obj.nil?
        nil
      else
        Dataset.new(obj.to_h)
      end
    end
  end
end
