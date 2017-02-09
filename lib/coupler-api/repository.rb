module CouplerAPI
  class Repository
    def initialize(adapter)
      @adapter = adapter
    end

    def self.dependencies
      ['adapter']
    end

    def find
      @adapter.find(@name).collect do |hsh|
        @constructor.new(hsh)
      end
    end

    def first(conditions)
      hsh = @adapter.first(@name, conditions)
      @constructor.new(hsh) unless hsh.nil?
    end

    def save(obj)
      hsh = obj.to_h
      if hsh[:id].nil?
        id = @adapter.create(@name, hsh)
        if id.nil?
          raise "adapter did not return an id"
        end
        obj.id = id
      else
        count = @adapter.update(@name, { id: hsh[:id] }, hsh)
        if count == 0
          raise "nothing was updated"
        end
      end
      obj
    end

    def delete(obj)
      hsh = obj.to_h
      count = @adapter.delete(@name, { id: hsh[:id] })
      if count == 0
        raise "nothing was deleted"
      end
      obj
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
