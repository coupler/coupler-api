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
        @constructor.new(unserialize(hsh))
      end
    end

    def first(conditions)
      hsh = @adapter.first(@name, conditions)
      @constructor.new(unserialize(hsh)) unless hsh.nil?
    end

    def save(obj)
      hsh = serialize(obj.to_h)
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

    protected

    def unserialize(hsh)
      hsh
    end

    def serialize(hsh)
      hsh
    end
  end
end
