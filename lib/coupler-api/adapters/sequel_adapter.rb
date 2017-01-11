require 'sequel'

module CouplerAPI
  class SequelAdapter
    def initialize(options)
      @options = options
    end

    def migrate(path)
      Sequel.extension(:migration)
      Sequel::Migrator.apply(db, path)
    end

    def find(name, conditions = nil)
      ds = db[name]
      if conditions
        ds = ds.where(conditions)
      end
      ds.all
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
      ds = db[name].where(conditions)
      result = ds.all
      ds.delete
      result
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
