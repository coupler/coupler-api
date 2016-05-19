module CouplerAPI
  class Repository
    def initialize(adapter)
      @adapter = adapter
    end

    def self.dependencies
      ['adapter']
    end

    def find
      @adapter.find(@name)
    end

    def first(conditions)
      @adapter.first(@name, conditions)
    end

    def create(data)
      @adapter.create(@name, data)
    end

    def update(conditions, data)
      @adapter.update(@name, conditions, data)
    end

    def delete(conditions)
      @adapter.delete(@name, conditions)
    end

    private

    def unserialize(obj)
      obj.to_h.rekey { |k| k.to_s }
    end

    def serialize(obj)
      obj.to_h.rekey { |k| k.to_sym }
    end
  end
end
