module Coupler::API
  class SequelAdapter
    def initialize(options)
      @options = options
    end

    def migrate(path)
      Sequel.extension(:migration)
      Sequel::Migrator.apply(db, path)
    end

    def schema(name)
      db.schema(name)
    end

    def find(name, conditions = nil, limit = nil, offset = nil)
      ds = db[name]
      ds = ds.where(conditions) if conditions
      ds = ds.limit(limit)      if limit
      ds = ds.offset(offset)    if offset
      ds.all
    end

    def count(name, conditions = nil)
      ds = db[name]
      if conditions
        ds = ds.where(conditions)
      end
      ds.count
    end

    def first(name, conditions)
      db[name].where(conditions).first
    end

    def create(name, data)
      db[name].insert(data)
    end

    def update(name, conditions, data)
      db[name].where(conditions).update(data)
    end

    def delete(name, conditions)
      db[name].where(conditions).delete
    end

    def close
      if @db
        @db.disconnect
      end
    end

    private

    def db
      unless @db
        @db = Sequel.connect(@options)
      end
      @db
    end
  end
end
